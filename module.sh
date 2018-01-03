/bin/ls -l
type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module unload git gcc ccache
module load git
module load gcc
module load ccache
#module load make
