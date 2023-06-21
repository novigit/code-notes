CONDA and MAMBA


#### uninstalling miniconda
```
rm -rf ~/miniconda3/
rm -rf ~/.conda
rm  ~/.condarc

# remove the conda block from your ~/.profile or ~/.bashrc
```

#### Creating and removing environments
```
# creating a new environment
conda create --name <my_env>

# create a new environment and install new packages at once
mamba create -n cogent3 -c bioconda cogent3

# install many packages at the same time using a YAML file
conda env create -n <my_env> -f <env.yml>

# remove an environment
conda env remove -n <my_env>

# remova a package from an environment
conda remove <package>
```

#### Search for packages
```
# search for packages
conda search -c bioconda <package>

# search for packages in already installed environments
conda search --envs <package>
mamba search --envs <package>

# get info of versions and build numbers of packages
conda search -c bioconda <package> --info
mamba search -c bioconda <package> --info
```

#### Install packages in pre-existing environments
```
# installing a packages in an environment
conda install -c bioconda -n <my_env> <package>=<version> <package>=<version>
# mamba is a lot faster at resolving environments!
mamba install -c bioconda -n <my_env> <package>=<version> <package>=<version>
```

#### Activate and Deactivate environments
```
conda activate <my_env>
conda deactivate
```

#### Listing packages and environments
```
# list all environments
conda env list

# list packages in current environment
conda list

# checkout the history of an environment
## package upgrades / downgrades, additions, removals etc
conda list -n <my_env> -r 
# -r is short for --revisions
```

#### Update packages
```
conda update <package>
mamba update <package>
```

#### Installing perl modules with conda
```
## install the module LWP:Simple
conda install perl-lwp-simple
## so essentially replace ':' in module name with '-',
## lower case everything, and add 'perl-'
```