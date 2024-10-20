# Listing all the nodes on the cluster

```bash
qhost
```

# Submitting jobs with qsub

```bash

# submit a job to a particular queue
qsub -q 256G-batch

# submit a job to multiple queues
qsub -q 256G-batch,768G-batch,2T-batch

# use the directory from which the script is called as working directory
qsub -cwd

# merge stderr and stdout stream into a single stream
qsub -j y[es]

# set a 'hard' run time (i.e. wall-clock time) limit
# how long are you allowing your job to run?
qsub -l h_rt 00:30:00

# submit a command without making a script
qsub -N <job_name> -b y "iqtree -s alignment.aln -nt 10 -m LG+G"

# it seems that to get -b y[es] "" to work, -N must be given as well
```

# Cancelling jobs

```bash

# cancel a particular job
qdel <job_id>

# cancel all jobs submitted by a user
qdel -u <user>
```

# Monitoring current jobs

```bash

qstat -j <job_id>
```

# Monitoring finished jobs

```bash

# check memory or other stuff from certain finished jobs
qacct -j <jobid>

# list all stats of all previous jobs of a certain user
qacct -o <userid> -j

# get list ids
qacct -o <userid> -j | grep jobnumber
```

# Checking the cluster, queue or node configuration

```bash
qconf -sq 768G-batch
```
