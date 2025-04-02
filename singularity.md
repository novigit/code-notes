Singularity

```bash

# download and run a container from the Singularity Container Library
singularity run library://godlovedc/funny/lolcow

# just download a container
singularity pull library://godlovedc/funny/lolcow
# downloads 'lolcow_latest.sif'
```

Pulling a container will download a SIF file from the container repository.

A SIF file

* is a Singularity Image Format file, in binary format

* contains an _image_ of a root level filesystem

* This filesystem is mounted on your _host_ filesystem

* Compressed and immutable

```bash

# enter a container's filesystem
singularity shell lolcow_latest.sif
```

The user remains the same inside and outside of the container.
So if I do `whoami`, it will still yield `joran`. This is also
true for if you run `hostname`, which would still yield `dolores`.
This is apparently attractive from a security and usability point of view.


```bash

# execute some executable that is part of the container
# you can also pass arguments to that executable
singularity exec lolcow_latest.sif cowsay 'How did you get out of the container?'
singularity exec lolcow_latest.sif echo 'ring ring hello'
singularity exec lolcow_latest.sif which cowsay

# pipe / redirect things
singularity exec lolcow_latest.sif cowsay moo | grep moo
singularity exec lolcow_latest.sif cowsay moo > cowsaid.txt

# if whatever tool you want to run inside the container also allows things to be piped INTO it,
# you can pipe things into the container, using singularity

# for example, cowsay can accept piped output with cowsay -n:
echo "Well hello there!" | cowsay -n
# ___________________
# < Well hello there! >
#  -------------------
#         \   ^__^
#          \  (oo)\_______
#             (__)\       )\/\
#                 ||----w |
#                 ||     ||

# this would yield the same result
echo "Well hello there!" | singularity exec lolcow_latest.sif cowsay -n

# if you want to pipe things within the containers execution, this wont work
singularity exec lolcow_latest.sif fortune | cowsay | lolcat
# because it will think you want to pipe the output of 'within-container' fortune to cowsay of the host system

# use this trick to pipe things within the container
singularity exec lolcow_latest.sif sh -c "fortune | cowsay | lolcat"
```

What actually happens when you 'run' a container?
It runs a so-called 'runscript', which you can check with `singularity --inspect`:

```bash

singularity inspect --runscript lolcow_latest.sif

##!/bin/sh
#
#    fortune | cowsay | lolcat

```

Since a SIF file is typically an executable file, you can also run the container like so

```bash
./lolcow_latest.sif
```

# Building containers

```bash

# create a lolcow/ directory from lolcow.def
# and build a sandbox type filesystem (which apparently is just a single directory)
sudo singularity build --sandbox lolcow lolcow.def

# create a lolcow.if from lolcow.def
sudo singularity build lolcow.sif lolcow.def
# NOTE that now we're not using --sandbox
# By omitting the --sandbox option, we are building our container in the
# standard Singularity file format (SIF). We are denoting the file format
# with the (optional) .sif extension. A SIF file is compressed and immutable
# making it a good choice for a production environment.
```

NOTE: if you enter this newly built container with `singularity shell lolcow`,
you won't have any sudo privileges! To enter it with sudo, you need to do
`sudo singularity shell lolcow`.

This is an important concept in Singularity. If you enter a container without
root privileges, you are unable to obtain root privileges within the container.
This insurance against privilege escalation is the reason that you will find
Singularity installed in so many HPC environments.

```bash

# enter a container as root
sudo singularity shell --writable lolcow
# 'whomai' returns 'root'

# now we can install stuff
# while in container, do:
Singularity> apt-get update
Singularity> apt-get install -y fortune cowsay lolcat
# tools are not automatically added to the PATH!
# so do it manually:
Singularity> export PATH=$PATH:/usr/games
```

# Definition files

```txt
BootStrap: debootstrap
OSVersion: stable
MirrorURL: http://ftp.us.debian.org/debian/

%runscript
    echo "This is what happens when you run the container..."

%post
    echo "Hello from inside the container"
    apt-get update
    apt-get -y install fortune cowsay lolcat

%environment
    export PATH=$PATH:/usr/games
```

```bash

# inspect a definition file from a SIF file
singularity inspect --deffile  lolcow.sif
```

# Building a container as fakeroot

In general, it’s a bad idea to build a container as root.
In particular you should never build a container from an untrusted base image as root
on a machine you care about. This is the same as downloading random code from the
internet and running it as root on your machine. It could be malware!

On operating systems with recent kernels (such as Ubuntu 18.04), you can invoke the
`--fakeroot` option when building containers instead.(For those interested in technical
details, this feature leverages the user namespace).

```bash

singularity build --fakeroot container.sif container.def

# instead of
sudo singularity build container.sif container.def
```

Using `--fakeroot` allows you to pretend to be the root user inside of your container without 
actually granting singularity elevated privileges on host system. This is a much 
safer way to build and interact with your container, and it is going to become more 
prevalent (eventually probably even default) as more distributions ship with user 
namespaces enabled. For instance, this feature is enabled by default in RHEL 8.


# Pulling pre-built containers from Docker Hub or Container Library

First, Docker Hub and the Container Library both have a concept of a tagged image.
Tags make it convenient for developers to release several different versions of the
same container. For instance, if you wanted to specify that you need Debian version 9,
you could do so like this:

```bash
singularity pull library://debian:9
```

Or within a definition file:

```txt
Bootstrap: library
From: debian:9
```

There is a special tag in both the Singularity Library and Docker Hub called __latest__.
If you omit the :<tag> suffix from your pull or build command or from within your
definition file you will get the container tagged with latest by default. This sometimes
causes confusion if the latest tag doesn’t exist for a particular container and an error
is encountered. In that case a tag must be supplied.


Pulling by the __latest__ tag, at different times, can result in your pulling 2 different
images with the same command. If you to ensure that you are pulling the same container multiple
times, you should pull by the __hash__:

```bash

# from Container Library
singularity pull library://debian:sha256.b92c7fdfcc6152b983deb9fde5a2d1083183998c11fb3ff3b89c0efc7b240448

# from Docker Hub
singularity pull docker://debian@sha256:f17410575376cc2ad0f6f172699ee825a51588f54f6d72bbfeef6e2fa9a57e2f
```


