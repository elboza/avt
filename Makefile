AC_FILE="aircraft_type_decode.avt"
GEO_FILE="geo_iata.avt"
ICAO_IATA_FILE="icao_iata.avt"
SSV_FILE="ssv.avt"
TC_FILE="ssv.avt"
LIB_DIR="/usr/share/avt/"
SRC_NAME=avt.rb
PROG_NAME=avt
DEST_DIR=/usr/bin/
PROG_VERSION=`cat avt.rb|grep "VERSION="|cut -d '"' -f2`
SHELL=/bin/bash

all:

.PHONY: install uninstall dist clean

install:
	echo "installing ${PROG_NAME} to ${DEST_DIR}"
	if [ ! -d ${LIB_DIR} ] ; then mkdir ${LIB_DIR} ; fi
	cp ${SRC_NAME} ${DEST_DIR}
	if [ ! -f ${DEST_DIR}${PROG_NAME} ] ; then ln -s ${DEST_DIR}${SRC_NAME} ${DEST_DIR}${PROG_NAME} ; fi
	chmod 755 ${DEST_DIR}${SRC_NAME}
	cp ${AC_FILE} ${LIB_DIR}
	cp ${GEO_FILE} ${LIB_DIR}
	cp ${ICAO_IATA_FILE} ${LIB_DIR}
	cp ${SSV_FILE} ${LIB_DIR}
	cp ${TC_FILE} ${LIB_DIR}
	chmod 444 ${LIB_DIR}${AC_FILE}
	chmod 444 ${LIB_DIR}${GEO_FILE}
	chmod 444 ${LIB_DIR}${ICAO_IATA_FILE}
	chmod 444 ${LIB_DIR}${SSV_FILE}
	chmod 444 ${LIB_DIR}${TC_FILE}
	ECHO "DONE."

uninstall:
	echo "uninstalling avt from system…"
	rm -f ${LIB_DIR}*
	rmdir ${LIB_DIR}
	rm -f ${DEST_DIR}${PROG_NAME}
	rm -f ${DEST_DIR}${SRC_NAME}
	echo "done."

dist:
	echo "making dist tarball…"
	mkdir ${PROG_NAME}
	cp ${SRC_NAME} ${PROG_NAME}
	cp ${AC_FILE} ${PROG_NAME}
	cp ${GEO_FILE} ${PROG_NAME}
	cp ${ICAO_IATA_FILE} ${PROG_NAME}
	cp ${SSV_FILE} ${PROG_NAME}
	cp ${TC_FILE} ${PROG_NAME}
	cp Makefile ${PROG_NAME}
	tar -czvf ${PROG_NAME}-${PROG_VERSION}.tar.gz ${PROG_NAME}/
	rm -f ./${PROG_NAME}/*
	rmdir ${PROG_NAME}
	echo "done."

clean:
	rm -f ./${PROG_NAME}/*
	rmdir ${PROG_NAME}

	
