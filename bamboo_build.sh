#!/bin/bash
env
pwd
ls -l
. ./module.sh
#set -vex
export FALCON_GIT_BRANCH=${bamboo.planRepository.1.branch}
export FALCON_GIT_URL=${bamboo.planRepository.1.repositoryUrl}
. ./env.sh
env | sort
#module load make
make --version
make fetch
