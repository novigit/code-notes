CONDA and MAMBA


#### Uninstalling miniconda
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

# remove/uninstall a package from the current environment
conda remove <package>
```

#### Environments defined in .yaml files
```
name: signalp6
channels:
    - bioconda
    - conda-forge
    - defaults
dependencies:
    - pip
    - pip:
        - signalp6==6.0+g
variables:
    FUNANNOTATE_DB: '/scratch4/db/funannotate/'
```

Hence, you can also add pip dependencies in your yaml file
Ensure that you have both `-pip` and `-pip:` in there!

The YAML file is thus also an excellent way to setup environment variables!

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

# revert back to an older revision of the environment
conda install --revision=REVNUM
# where REVNUM is the revision number, for example 2
# this will create a new revision number in the revision history,
# so if you are in rev 3, but you would like to return to 2, doing so
# will yield rev 4, which should be identical to rev 2

# export name, channels and all packages of a current active environment
conda env export > environment.yaml
mamba env export > environment.yaml
```

#### Update packages
```
conda update <package>
mamba update <package>
```

#### Renaming a conda environment
As far as I know there is not a direct rename option, but it is possible
to copy an old environment to a new environment with a new name, and then
delete the old environment
```
conda activate old_environment_name
conda env export > environment.yml
```
Now edit the name of the environment in the YML file to the new name. Then

```
conda env create -f environment.yml --name new_environment_name

conda deactivate
conda env remove --name old_environment_name
```

#### Installing perl modules with conda
```
## install the module LWP:Simple
conda install perl-lwp-simple
## so essentially replace ':' in module name with '-',
## lower case everything, and add 'perl-'
```

If the above method doesn't work, because it may not be available on
a conda channel, or you don't know the right name, try the following
```
## install cpanminus
conda install perl-app-cpanminus

## install the desired perl module
cpanm Color::ANSI::Util

## or
env PERL5LIB="" PERL_LOCAL_LIB_ROOT="" PERL_MM_OPT="" PERL_MB_OPT="" $CONDA_PREFIX/bin/cpanm Color::ANSI::Util
```

If you are working on a Mac, you may need to install xcode first.
On the command line, run
`xcode-select --install`

Check the conda environment's library to check if the modules are installed in the right place
```sh
l /Users/joran/miniconda3/envs/colorFastq/lib/perl5/site_perl/

# should inlude Color/ANSI/Util.pm
```

