# Introduction

Snakemake is a workflow management system (WMS)

It's based on a 'pull' kind of system.
You ask for output files and snakemake will use your Snakefile to figure out how to generate the requested output files (pull).
With a bash pipeline you provide the input files and bash will use the bash script to generate the output files (push)

# Snakefile tips

### expand() 
Useful to compactly state your desired output files in the all rule
```py
expand('{sample}.{direction}.fastqc.html', sample = ['sample1','sample2'], direction = ['fw', 'rv'])

```
This will generate
```
sample1.fw.fastqc.html
sample1.rv.fastqc.html
sample2.fw.fastqc.html
sample2.rv.fastqc.html
```

### input function
Useful to process outputs from different parts of the pipeline in a single rule

Input functions need to be stated _above_ the rules that call them

If you have a _single_ input file that is different depending on the requested output:
```py
def get_fastq(wildcards):
    if wildcards.sample == 'sample1':
        return 'sample1/sample1.fw.fastq.gz'
    elif wildcards.sample == 'sample2':
        return 'sample2/sample2.fw.fastq.gz'

rule fastqc:
    input: get_fastq
```

If you have _multiple_ input files that are different depending on the requested output:
```py
def get_pilon_input(wildcards):
    input_dict = {
        'assembly' : '{wildcards.assembly}.fasta'.format(wildcards = wildcards),
        'bam'      : '{wildcards.assembly}.bam'.format(wildcards = wildcards)
    }
    return input_dict

rule pilon:
    input: unpack(get_pilon_input)
    shell: 'pilon --genome {input.assembly} --bam {input.bam}'
```

### lambda expressions
Useful if there is a maximum amount of threads you can use per 'job'
```py
rule repeatmasker:
    threads: 8
    params:
        jobs=lambda wildcards, threads : threads // 4
    shell: 'RepeatModeler -p {params.job}'
```
`//` means floor division. E.g., 9 // 4 = 2


### local rules
These are rules which will _not_ be submitted to compute nodes on a computer cluster.
In other words, these are rules executed by the head-node / login-node.
```py
localrules: all, rule_a, rule_b
```

### temp()
Mark output files with temp() to delete them once all rules
that use those output files are completed
```py
output: temp('outfile')
```

### using {} in shell
```py
shell: 'awk {{ print $0 }}'
```

# Snakemake command line

| Option                     | Explanation                                                                                                         |
|----------------------------|---------------------------------------------------------------------------------------------------------------------|
| `-S snakefile.smk`         | Run a snakefile that is not called `Snakefile`                                                                      |
| `--dry-run / -n`           | Check `Snakefile` for syntax errors, pipeline connectiveness and which rules and jobs will be executed              |
| `--reason / -r`            | State why each reason was activated                                                                                 |
| `--printshellcmds / -p`    | State exact shell commands used for each rule or job                                                                |
| `--cores 40`               | Set the total number of cores that can be used                                                                      |
| `--use-conda`              | Use conda environments defined in the rules. Can be pre-existing conda environment, or an environment YAML file     |
| `--conda-create-envs-only` | Installs all necessary conda packages, but does NOT run the pipeline                                                |
| `--rerun-triggers mtime`   | Define conditions for rerunning a rule. Default is `mtime,params,input,software_env,code`, which is very aggressive |
| `--touch file`             | Mark a `file` as up to date, even if its mtime is older than upstream files                                         |
| `--unlock`                 | Unlock a working directory. Snakemake workdirs can get locked if a pipeline crashed in an abnormal way<\**>          |

\* For example Ctrl-C, power outage, HPC job that ran out of time

### generate a jobgraph and rulegraph
```sh
snakemake --dag       | dot -Tpng > jobgraph.png
snakemake --rulegraph | dot -Tnpg > rulegraph.png
```
### activate a conda environment created by snakemake
```sh
source activate .snakemake/conda/<env>
```
Here <env> is the MD5 hash of the environment definition file content ??

# Executing snakemake on a HPC cluster

Snakemake is able to delegate snakejobs as separate jobs to the queue of a computer cluster.

```sh
snakemake --cluster 'qsub -V'
snakemake --cluster 'sbatch'
```

If you are on a Sun Grid Engine cluster (qsub), make sure you are in
the environment that has all required tools loaded before executing the snakefile. 
`-V` ensures that your environment variables are passed on to the submitted job

### various --cluster options

```sh
# submit each snakejob with the number of threads specified in the rule
snakemake --cluster 'qsub -V -pe threaded {threads}'

# limit the number of jobs that can be submitted to the HPC queue at the same time
snakemake --cluster 'qsub -V' --jobs 6

# specify the location of the STDOUT and STDERR files of each submitted snakejob
snakemake --cluster 'qsub -V -cwd -o logs/{rule}.{jobid}.o -e logs/{rule}.{jobid}.e'
## Here {rule} and {jobid} are special wildcards holding the rule name and jobid of the snakejob, respectively.
## If not specified, the STDOUT and STDERR files are stored in your $HOME.
## -cwd ensures that the relative paths of -o and -e are relative to your working dir instead relative to your $HOME
```

# Other notes

Output directories specified in your rules are automatically made my Snakemake. So no need for `mkdir` in the `shell:`

After a rule is executed, snakemake will check if all your desired output files stated in `output:` are actually present in your filesystem.
If at least one of them is not present, snakemake will assume the rule executation failed and remove all files generated by that rule / job


