```sh
# submit a job to a particular queue
qsub -q 256G-batch

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
