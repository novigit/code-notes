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

The `Client` is an abstraction of the entity that collects the tasks,
and pass them to the `Scheduler` whom them passes them on the the
`Workers` in an organized manner. The workers then compute the
tasks in parallel to each other.

The `Scheduler` looks at all the tasks, constructs a task graph,
and assigns each worker a workload of tasks according to that graph.
Each worker then computes each of those assigned tasks serially,
gradually chipping away at its backlog.

In a Computer Cluster environment, its the `Cluster` object that
contains the scheduler in `cluster.scheduler` and the workers
in `cluster.workers`.

```python

# import modules
from dask_jobqueue import SGECluster
from dask.distributed import Client
```

# A Cluster object

The number of `cores` and `memory` specified here is essentially the
resource allocation to a single 'dask_worker'.

The object just stores your specifications. Nothing is actually submitted to the cluster yet.

The number of `processes` specifies the number 'Python processes'.
Apparently dask is able to split up the tasks in a script to individual python processes,
to satisfy the GIL? Yes, I think so

The `queue` parameter should be equal to what you would specify with
`qsub -q`

On Perun, it's important that you specify the `-V` parameter to pass the environment variables,
including the `$PATH` to the dask_worker. Otherwise they may not be able to actually find
iqtree or mafft or whatever executable you want to run.

```python

# configure the SGE cluster
cluster = SGECluster(
    cores=10,
    memory="64GB",
    walltime="99:99:99",
    resource_spec="h_vmem=64G",
    queue='256G-batch',
    job_extra=['-cwd', '-V']
    processes=1,
)
```

* In SGE clusters, iff you want a specific amount of RAM, you must specify both the `memory` parameter,
as well as the `resource_spec` parameter. NOTE that in the resource_spec, specify 64G, not 64GB!!
The resource_spec value is directly passed to `qsub -l` option.

* On Perun, to ensure that your job finishes in time, use the `99:99:99` value for walltime.
Its `HH:MM:SS` as format. Dask will transform this value into seconds, and pass it on to `qsub -l h_rt=`.


# Launching dask workers

```python

# launch 10 dask workers
cluster.scale(n=10)

# launch 10 jobs
cluster.scale(jobs=10)
```

This will submit an x number of jobs to the computer cluster,
each of which will, during job execution, launch a python process.
If `processes=1`.

Each of those processes will have a `cores` number of cores and a `memory`
amount of memory available to them, as specified by the `cluster` object.

NOTE that it may take a moment for these jobs to run on the computer cluster.
We are still at the mercy of the computer clusters' scheduler here.

Currently, for some reason, each dask_worker only occupies 1 "slot" on Perun,
even if you specify 2 or more cores when you specify SGECluster(). However,
the job that does get run does run with multiple cores no problem.

# A Client object

The client allows Dask to connect the to-be executed tasks to the remote workers,
as defined in the cluster object. 

```python

# create a Dask client
# and attach it to the scheduler
# within the cluster
client = Client(cluster)
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
