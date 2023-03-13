# Introduction

Snakemake is a workflow management system (WMS)

It's based on a 'pull' kind of system.
You ask for output files and snakemake will use your Snakefile to figure out how to generate the requested output files (pull).
With a bash pipeline you provide the input files and bash will use the bash script to generate the output files (push)

# Snakefile tips

### expand() 

```py
expand('{sample}.{direction}.fastqc.html', sample = ['sample1','sample2'], direction = ['fw', 'rv'])
## will generate
## sample1.fw.fastqc.html
## sample1.rv.fastqc.html
## sample2.fw.fastqc.html
## sample2.rv.fastqc.html
# useful to compactly state your desired output files in the all rule
```

### input function

```py

def get_fastq(wildcards):
    if wildcards.sample == 'sample1':
        return 'sample1/sample1.fw.fastq.gz'
    elif wildcards.sample == 'sample2':
        return 'sample2/sample2.fw.fastq.gz'

rule fastqc:
    input: get_fastq
```


Useful to process outputs from different parts of the pipeline in a single rule

def get_pilon_input(wildcards):
    input_dict = {
        'assembly' : '{wildcards.assembly}.fasta'.format(wildcards = wildcards),
        'bam'      : '{wildcards.assembly}.bam'.format(wildcards = wildcards)
    }
    return input_dict

rule pilon:
    input: unpack(get_pilon_input)
    shell: 'pilon --genome {input.assembly} --bam {input.bam}'
## useful if you have multiple input files that vary depending on the requested output

## input functions need to be stated ABOVE the rules that call them in the Snakefile


# using a lambda expression
rule repeatmasker:
    threads: 8
    params:
        jobs=lambda wildcards, threads : threads // 4
    shell: 'RepeatModeler -p {params.job}'
## useful if there is a maximum amount of threads you can use per 'job'
## // means floor division. E.g., 9 // 4 = 2


# define which rules should not be submitted to the cluster
# i.e., execute these on the headnode
localrules: all, rule_a, rule_b


# using {} in shell: that is not a wildcard thingy
    shell: 'awk {{ print $0 }}'


# temp()
## mark output files with temp() to delete them once all rules
## that use those output files are completed
    output: temp('outfile')

# SNAKEMAKE COMMAND LINE - TIPS AND TRICKS

# do a dry-run
## check if snakefile is written correctly, w/o any syntax errors etc
## and the rules are properly connected etc
snakemake --dry-run / -n

# verbose reason why each rule was activated
snakemake --reason / -r

# verbose the exact shell commands used per rule / job
snakemake --printshellcmds / -p

# run a snakefile that is not called Snakefile
snakemake -S assembly_genome.smk

# make jobgraph and rulegraph
snakemake --dag | dot -Tpng > jobgraph.png
snakemake --rulegraph | dot -Tnpg > rulegraph.png

# set the total number of cores/threads that can be used
snakemake --cores 40

# use tools specified in conda enviroments or environment YAML files
snakemake --use-conda
# only install the conda packages, do not run the pipeline
snakemake --use-conda --conda-create-envs-only
# activate a conda environment created by snakemake
source activate .snakemake/conda/<env>
## where <env> is the MD5 hash of the environment definition file content ??

# run a snakefile on an HPC cluster
snakemake --cluster 'qsub -V'
snakemake --cluster 'sbatch'
# each 'snakejob' will be submitted seperately with qsub / sbatch
## when on a Sun Grid Engine cluster, make sure you are in
## the environment that has all required tools loaded
## before executing the snakefile. 
## -V ensures that your environment variables are passed on to the submitted job

# submit each snakejob with the number of threads specified in the rule
snakemake --cluster 'qsub -V -pe threaded {threads}'

# limit the number of jobs that can be submitted to the HPC queue at the same time
snakemake --cluster 'qsub -V' --jobs 6

# specify the location of the STDOUT and STDERR files of each submitted snakejob
snakemake --cluster 'qsub -V -cwd -o logs/{rule}.{jobid}.o -e logs/{rule}.{jobid}.e'
## where {rule} and {jobid} are special wildcards holding the rule name and jobid of the snakejob, respectively
## if not specified, the STDOUT and STDERR files are stored in your $HOME
## -cwd ensures that the relative paths of -o and -e are relative to your working dir instead relative to your $HOME

# only trigger a rerun using modification times
snakemake --rerun-triggers mtime
## default is mtime,params,input,software_env,code
## which is very aggressive

# mark certain output files as up-to-date, so
# that their associated rule will not rerun even if their input files are newer
snakemake --touch outputfile

# unlock the working directory
## working dirs can be locked if pipeline execution is cancelled / crashed artificially
## examples: Ctrl-C, power outage, cluster job ran out of time, etc
snakemake --unlock

# SNAKEMAKE GENERAL EXECUTION NOTES

# - Output directories specified in your rules are automatically made my Snakemake. So no need for 'mkdir' in the 'shell:'

# - After a rule is executed, SNAKEMAKE will check if all your desired output files stated in 'output:' are actually present in your filesystem.
# If at least one of them is not present, SNAKEMAKE will assume the rule executation failed and remove all files generated by that rule / job


