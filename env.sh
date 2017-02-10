/bin/ls -l

export PATH=/mnt/software/a/anaconda2/4.2.0/bin:$PATH
export PYTHONUSERBASE=$(pwd)/LOCAL
#export FALCON_GIT_BRANCH=${bamboo.planRepository.branch}
#export FALCON_GIT_URL=${bamboo.planRepository.repositoryUrl}
if [[ -z $FALCON_GIT_BRANCH ]]; then
  export FALCON_GIT_BRANCH=$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')
fi
if [[ -z $FALCON_GIT_URL ]]; then
  export FALCON_GIT_URL=$(git config --get remote.origin.url)
fi
export FALCON_WORKSPACE=BUILD
export FALCON_PREFIX=${PYTHONUSERBASE}

export MY_GIT_URL=${FALCON_GIT_URL}

git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///'
git config --get remote.origin.url
git remote -v
