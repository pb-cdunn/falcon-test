/bin/ls -l
type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module unload git gcc ccache
module load git/2.8.3
module load gcc/4.9.2
module load ccache/3.2.3
#module load make
