# Required:
#   FALCON_PREFIX
#   FALCON_WORKSPACE
# Optional:
#   FALCON_PIP_EDIT
#   FALCON_PIP_USER
#   FALCON_INSTALL_RULE (symlink or install)
#   FALCON_GIT_BRANCH
#   PYTHONUSERBASE

#FALCON_WORKSPACE?=BUILD/
#FALCON_PREFIX?=LOCAL/
FALCON_PIP_EDIT?=--edit
FALCON_PIP_USER?=--user
FALCON_INSTALL_RULE?=symlink
FALCON_GIT_BRANCH?=master
export CC=gcc
export CXX=g++

init: # Some requirements prior to install
	mkdir -p ${FALCON_PREFIX}/bin
	mkdir -p ${FALCON_PREFIX}/lib
	mkdir -p ${FALCON_PREFIX}/include
	rm -f BUILD/DAZZ_DB
	ln -sf dazz_db BUILD/DAZZ_DB
fetch:
	py/fetch.py --branch ${FALCON_GIT_BRANCH} --dir BUILD -u
help:
	py/fetch.py -h
install: install-dazz-db install-daligner install-damasker install-dextractor install-pypeFLOW install-FALCON
install-dazz-db:
	${MAKE} -C ${FALCON_WORKSPACE}/dazz_db all
	PREFIX=${FALCON_PREFIX} ${MAKE} -C ${FALCON_WORKSPACE}/dazz_db ${FALCON_INSTALL_RULE}
install-daligner: install-dazz-db
	${MAKE} -C ${FALCON_WORKSPACE}/daligner all
	PREFIX=${FALCON_PREFIX} ${MAKE} -C ${FALCON_WORKSPACE}/daligner ${FALCON_INSTALL_RULE}
install-damasker:
	${MAKE} -C ${FALCON_WORKSPACE}/damasker all
	PREFIX=${FALCON_PREFIX} ${MAKE} -C ${FALCON_WORKSPACE}/damasker ${FALCON_INSTALL_RULE}
install-dextractor:
	${MAKE} -C ${FALCON_WORKSPACE}/dextractor all
	PREFIX=${FALCON_PREFIX} ${MAKE} -C ${FALCON_WORKSPACE}/dextractor ${FALCON_INSTALL_RULE}
install-pypeFLOW:
	cd ${FALCON_WORKSPACE}/pypeFLOW; pip uninstall -v .; pip install -v ${FALCON_PIP_USER} ${FALCON_PIP_EDIT} .
install-FALCON: install-pypeFLOW
	cd ${FALCON_WORKSPACE}/FALCON; pip uninstall -v .; pip install -v ${FALCON_PIP_USER} ${FALCON_PIP_EDIT} .
