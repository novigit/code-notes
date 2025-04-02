DASK
Making use of a high performance computer cluster to parallelize tasks

The DASK abstraction of distributing computation is roughly as follows:

             +------------------+
             |      CLIENT      |
             +------------------+
                       |
             +------------------+
             |     SCHEDULER    |
             +------------------+
            /          |         \
    +------------+ +------------+ +------------+
    |   WORKER   | |   WORKER   | |   WORKER   |
    +------------+ +------------+ +------------+
       /     \        /      \       /      \
    +----+  +----+ +----+  +----+ +----+  +----+
    | p1 |  | p2 | | p1 |  | p2 | | p1 |  | p2 |
    +----+  +----+ +----+  +----+ +----+  +----+
      / \    / \     / \     / \    / \     / \
     t1 t2  t1 t2   t1 t2   t1 t2  t1 t2   t1 t2

# TLDR

- First you collect your **Tasks** in your script. 
You then pass on those tasks to the _Client_.

- The client has a number of "tasks" that need to be executed

- The client passes them on to the _Scheduler_
  - The scheduler launches a number of _Workers_ through SGE _Jobs_, one worker per job
  - Each job has a reserved number of cores. Ensure that is sufficient for your workload 
  - It should also be possible to reserve an amount of memory for the job, but I'm not sure yet how that works

- The scheduler distributes the tasks among the workers

- Each worker can be assigned one or more python _Processes_

- Each of these processes can get one or more _Threads_

- Each thread carries out one **Task** at a time

- I'm guessing that you want few processes, many threads, if your tasks are I/O bound,
or for whatever reason your CPU cores need to do a lot of waiting.
And you'll want many processes, few threads if your tasks are CPU bound,
i.e. the CPUs are constantly busy

- These threads carry out Python code! So if you are calling external software,
for example with `subprocess.run()`, they are only responsible for the execution
of the subprocess.run() call. They won't partake in the external software execution.
This thread is just waiting around for the subprocess to finish, so its like an I/O bound
task.

# More details

The `Client` is an abstraction of the entity that collects the tasks,
and pass them to the `Scheduler` whom them passes them on the the
`Workers` in an organized manner. The workers then compute the
tasks in parallel to each other.

The `Scheduler` looks at all the tasks, constructs a task graph,
and assigns each worker a workload of tasks according to that graph.
Each worker then computes each of those assigned tasks,
gradually chipping away at its backlog. The worker may still,
depending on your cluster configuration, compute many tasks
in parallel.

In a Computer Cluster context, its the `Cluster` object that
contains the scheduler in `cluster.scheduler` and the workers
in `cluster.workers`.

# Setting up dask in your script

```python

# import modules
from dask_jobqueue import SGECluster
from dask.distributed import Client
```

```python

# configure the SGE cluster
cluster = SGECluster(

    # job resources
    walltime="99:99:99",
    resource_spec="h_vmem=64G",
    queue='256G-batch',
    job_extra=['-cwd', '-V', '-pe threaded 10'],

    # worker resources
    cores=1,
    processes=1,
    memory="1GB",
)
```

# The Cluster object

The `cluster` object just stores your specifications. Nothing is actually submitted to the cluster yet.

The number of `cores` and `memory` specified here is essentially the
resource allocation to a single 'dask_worker'.
NOTE: I think, when they say "cores", they actually mean "threads".

The number of `processes` specifies the number 'Python processes'.
The cores and memory get divided up into n equal parts, where n is the number of specified processes.
So for example, if you have 100GB and 10 threads per worker, but 5 processes,
Each process gets 20 GB of memory and 2 threads to work with.

On Perun, it's important that you specify the `-V` parameter to pass the environment variables,
including the `$PATH` to the dask_worker. Otherwise they may not be able to actually find
iqtree or mafft or whatever executable you want to run.

As far as I'm aware, the jobs submitted by the scheduler do not actually contain a
core / thread reservation. To do so, you have to pass `-pe threaded 10` to
the `job_extra` parameter. Otherwise, in `qstat`, you'll see 1 slot, instead of e.g. 10 slots.

The `walltime` (`-l h_rt=`), `resource_spec` (`-l h_vmem=`), `queue` (`-q`) 
and `job_extra` (`-V`, `-cwd`, `-pe threaded 10`, ) parameters are all directly passed on to qsub

In SGE clusters, if you want a specific amount of RAM, you must specify both the `memory` parameter,
as well as the `resource_spec` parameter. NOTE that in the resource_spec, specify 64G, not 64GB!!
The resource_spec value is directly passed to `qsub -l` option.
However, on Perun, it doesn't seem to be possible to reserve a portion of RAM for your job..

Because the variety of Grid Engine derivatives and configuration deployments,
it is not possible to use the memory keyword argument to automatically specify the amount of RAM requested. 
Instead, you specify the resources desired according to how your system is configured,
using the resource_spec keyword argument, in addition to the memory keyword argument

On Perun, to ensure that your job finishes in time, use the `99:99:99` value for walltime.
Its `HH:MM:SS` as format. Dask will transform this value into seconds, and pass it on to `qsub -l h_rt=`.

See how this translates to qsub as follows:

```python
print(cluster.job_script())
```

Which results in

```bash
#!/usr/bin/env bash

#$ -N dask-worker
#$ -q 768G-batch
#$ -l h_vmem=64G
#$ -l h_rt=99:99:99
#$ -cwd
#$ -j y
#$ -cwd
#$ -V

/scratch2/software/anaconda/envs/FunDiWrapper/bin/python -m \
    distributed.cli.dask_worker tcp://192.168.2.21:35413 \
    --nthreads 10 \
    --memory-limit 64.00GB \
    --name dummy-name \
    --nanny \
    --death-timeout 60 \
    --protocol tcp://
```

If you specified in `SGECluster()` that you wanted 2 processes, it would yield the same
bash script, but with `--nthreads 5` and `--nprocs 2` and `--memory-limit 32.00GB`

Thus, each worker gets allocated a number of python processes.
And each process gets a memory limit and a threads/cores limit, such that when all processes run at the same time,
the stated overall memory limit and threads/cores limit is not exceeded.

* Setting multiple processes per worker can be useful if your workload is CPU bound
(Similar to using ProcessPoolExecutors() or multiprocessing in vanilla python)

* `-j y` indicates that you want to merge STDOUT and STDERR in your output.

* Apparently passing '-cwd' was unnecessary, the resultant script, now has two instances of -cwd.

* A nanny is a wrapper for the worker that handles restarting the process if it is killed.


# Launching dask workers

```python

# launch 10 dask workers
cluster.scale(n=10)

# launch 10 jobs
cluster.scale(jobs=10)
```

This will submit an x number of jobs to the computer cluster,
each of which will, during job execution, launches a dask worker.
If `processes=1`, the worker gets 1 python process to work with.

Each of those processes will have a `cores` number of cores and a `memory`
amount of memory available to them, as specified by the `cluster` object.

NOTE that it may take a moment for these jobs to run on the computer cluster.
We are still at the mercy of the computer clusters' scheduler here.


# A Client object

The client allows Dask to connect the to-be executed tasks to the remote workers,
as defined in the cluster object. 

```python

# create a Dask client
# and attach it to the scheduler
# within the cluster
client = Client(cluster)
```

After you're done with your tasks, you can close or shutdown the client:

```python

# Disconnects the Client from the cluster,
# but leaves the cluster itself running
client.close()

# Disconnects the Client from the cluster,
# and shuts down the cluster entirely
client.shutdown()
```
# Storing tasks in a list of Future objects

The list sort of contains a list of the many tasks that need to be done,
and that can be executed in parallel.

```python

some_input = [1, 2, 3, 4, 5, 6]
def some_function(x):
    ....

# generate list of Future objects with client.map()
## as far as I understand this doesn't yet actually start computation
## update: maybe it does? Future objects contain information on a running process
futures = client.map(some_function, some_input)
```

# Collect computation results

I think this is the step that actually starts computation,
and waits until all tasks have been computed.

```python

# Gather results
results = client.gather(futures)
```

# Dask Delayed

Instead of using `client.map()` to generate a list of Future objects,
you can also do this manually with Dask Delayed. This can be useful,
for instance if your function has more than one input parameter,
or if you want to submit other software tools from within python
using `subprocess.run()`

```python

from dask import delayed

some_input = []
def some_function(x):
    ...

delayed_tasks = [ delayed(some_function)(x) for x in some_input ]

# compute the delayed tasks in parallel
futures = client.compute(delayed_tasks)

# gather results
results = client.gather(futures)
```

or

```python

import subprocess
from dask import delayed

delayed_tasks = []
def run_command(cmd):
    result = subprocess.run(cmd, stderr=subprocess.DEVNULL)

alignments = [ 'aln1', 'aln2', 'aln3' ]
for aln in alignments:
    iqtree_command = [ 'iqtree', '-s', aln, '-nt', '10' ]
    delayed_tasks.append( delayed(run_command)(iqtree_cmd) )

# Compute the delayed tasks in parallel
futures = client.compute(delayed_tasks)

# Gather results
results = client.gather(futures)
```

or more directly (without defining a separate function)

```python

delayed_tasks = []
alignments = [ 'aln1', 'aln2', 'aln3' ]
for aln in alignments:
    iqtree_command = [ 'iqtree', '-s', aln, '-nt', '10' ]
    delayed_tasks.append( delayed(subprocess.run)(iqtree_cmd, stderr=subprocess.DEVNULL) )
```

NOTE the strange syntax `delayed(run_command)(iqtree_command)`
or `delayed(some_function)(x)`. This is because delayed is a 
decorator-like function that returns a new function, which,
when called, creates a Delayed object.

So `delayed(some_function)` actually returns another function,
of which the input is written in the next pair of parenthese, 
here `(iqtree_command)` and `(x)`

A subprocess inherits the resource limits of its parent process

# Closing a cluster

If you are done with dask at a point in your script, and you don't
need it anymore, you can simply state `cluster.close()` to gracefully
stop all dask workers. This will release any `dask-worker-space` directories,
and/or other dask worker files, so they can be safely removed.

## What if workers are still in the job queue by the time the Dask script reaches the compute stage?

It is possible to reach the compute stage before the Dask workers are
fully up and running, especially when using a job queue system where 
workers are scheduled by an external cluster scheduler like SGE, SLURM, 
PBS, etc. This situation can occur because there might be a delay in 
scheduling and starting the workers.

Dask handles this situation gracefully. When you call the compute method 
or other operations that require workers, Dask will wait for the workers 
to become available before proceeding with the computation.

You can also apparently force Dask to wait with
`client.wait_for_workers`

```python

# Scale the cluster to the desired number of workers
cluster.scale(10)  # Request 10 workers

# Create a Dask client
client = Client(cluster)

# Wait for workers to be ready
client.wait_for_workers(n_workers=10)
```
