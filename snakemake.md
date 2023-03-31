## Introduction

Snakemake is a workflow management system (WMS)

It's based on a 'pull' kind of system.
You ask for output files and snakemake will use your Snakefile to figure out how to generate the requested output files (pull).
With a bash pipeline you provide the input files and bash will use the bash script to generate the output files (push)

## Snakefile tips

#### expand() 
```py
expand('{sample}.{direction}.fastqc.html', sample = ['sample1','sample2'], direction = ['fw', 'rv'])

# This will generate
sample1.fw.fastqc.html
sample1.rv.fastqc.html
sample2.fw.fastqc.html
sample2.rv.fastqc.html

# Useful to compactly state your desired output files in the all rule
```

#### input functions
```py
# input function
def get_fastq(wildcards):
    if wildcards.sample == 'sample1':
        return 'sample1/sample1.fw.fastq.gz'
    elif wildcards.sample == 'sample2':
        return 'sample2/sample2.fw.fastq.gz'

# rule using input function
## needs to be stated below the input function in the snakefile
rule fastqc:
    input: get_fastq

# Useful if your rule requires a single input file, but the input file
# is different depending on which upstream rule is used


# input function
def get_pilon_input(wildcards):
    input_dict = {
        'assembly' : '{wildcards.assembly}.fasta'.format(wildcards = wildcards),
        'bam'      : '{wildcards.assembly}.bam'.format(wildcards = wildcards)
    }
    return input_dict

# rule using input function
## needs to be stated below the input function in the snakefile
rule pilon:
    input: unpack(get_pilon_input)
    shell: 'pilon --genome {input.assembly} --bam {input.bam}'

# Useful if your rules requires multipe input files, but that set of input files
# is different depending on which upstream rule is used
```

#### lambda expressions
```py
rule repeatmasker:
    threads: 8
    params:
        jobs=lambda wildcards, threads : threads // 4
    shell: 'RepeatModeler -p {params.job}'

# Useful if there is a maximum amount of threads you can use per 'job'
# // means floor division. E.g., 9 // 4 = 2
```


#### local rules
```py
localrules: all, rule_a, rule_b

# These are rules which will not be submitted to compute nodes on a computer cluster.
# In other words, these are rules executed by the head-node / login-node.
```

#### temp()
```py
output: temp('outfile')

# Mark output files with temp() to delete them once all rules
# that use those output files are completed
```

#### using {} in shell
```py
shell: 'awk {{ print $0 }}'

# { and } have special meaning in the shell directive,
# so if they are used in a command you need to add another { and } to escape the special meaning?
```

## Snakemake command line
```sh
# Run a snakefile that is not called `Snakefile`
snakemake -S some_snakefile.smk

# Generate a jobgraph and rulegraph
snakemake --dag       | dot -Tpng > jobgraph.png
snakemake --rulegraph | dot -Tnpg > rulegraph.png

# Check `Snakefile` for syntax errors, pipeline connectiveness and which rules and jobs will be executed
snakemake --dry-run / -n
## NOTE: when doing a dry-run the yellow text will report using only 1 thread for a job,
## even if you requested multiple threads in the relevant rule. Not to worry,
## snakemake will execute a rule with the requested number of threads in a normal run

# State reason why each rule was activated
snakemake --reason / -r

# State exact shell commands used for each rule or job
snakemake --printshellcmds / -p

# Set the total number of cores that can be used
snakemake --cores 40

# Use conda environments defined in the rules
## Can be pre-existing conda environment, or an environment YAML file
snakemake --use-conda

# Installs all necessary conda packages, but does NOT run the pipeline
snakemake --conda-create-envs-only

# Activate a conda environment created by snakemake
## Here <env> is the MD5 hash of the environment definition file content ??
source activate .snakemake/conda/<env>

# Define conditions for rerunning a rule. 
## Default is mtime,params,input,software_env,code, which is very aggressive
snakemake --rerun-triggers mtime

# Mark a file as up to date, even if its mtime is older than upstream files
snakemake --touch file

# Unlock a working directory
## Snakemake workdirs can get locked if a pipeline crashed in an abnormal way
## For example Ctrl-C, power outage, HPC job that ran out of time
snakemake --unlock
```


## Executing snakemake on a HPC cluster
```sh
# Snakemake is able to delegate snakejobs as separate jobs to the queue of a computer cluster
snakemake --cluster 'qsub -V'
snakemake --cluster 'sbatch'
# If you are on a Sun Grid Engine cluster (qsub), make sure you are in
# the environment that has all required tools loaded before executing the snakefile
# `-V` ensures that your environment variables are passed on to the submitted job

# Submit each snakejob with the number of threads specified in the rule
snakemake --cluster 'qsub -V -pe threaded {threads}'

# Limit the number of jobs that can be submitted to the HPC queue at the same time
snakemake --cluster 'qsub -V' --jobs 6

# Specify the location of the STDOUT and STDERR files of each submitted snakejob
snakemake --cluster 'qsub -V -cwd -o logs/{rule}.{jobid}.o -e logs/{rule}.{jobid}.e'
## Here {rule} and {jobid} are special wildcards holding the rule name and jobid of the snakejob, respectively.
## If not specified, the STDOUT and STDERR files are stored in your $HOME.
## -cwd ensures that the relative paths of -o and -e are relative to your working dir instead relative to your $HOME

# If you have rules that point to specific conda environments, e.g. conda: 'funannotate',
# then make sure that there are no conflicting versions of softwares between 
# the environment where you are submitting the snakemake pipeline from (e.g. 'proj-ergo', or 'snakemake')
# and the conda environment. 
#
# I had one issue where funannotate was calling the wrong version of diamond,
# even though the 'funannotate' environment had the correct version installed,
# because the environment that I was calling snakemake from, had an earlier version
# of diamond, and in the jobs environment that version's path preceeded the correction version's path
# in $PATH
```


## Using conda environments on a HPC cluster
```sh
# If you have a rule with `conda: env.yaml`, snakemake will download 
# and install the requested packages under `.snakemake/conda/<env>` 
# where `<env>` is an MD5 hash. The rule will be run with the software installed there.
```

## Other notes
```sh
# Output directories specified in your rules are automatically made my Snakemake. 
# So no need for mkdir in the shell: directive

# After a rule is executed, snakemake will check if all your desired output files 
# stated in output: are actually present in your filesystem
# If at least one of them is not present, snakemake will assume the rule executation failed 
# and remove all files generated by that rule / job
```

