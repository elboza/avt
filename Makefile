AC_FILE="aircraft_type_decode.avt"
GEO_FILE="geo_iata.avt"
ICAO_IATA_FILE="icao_iata.avt"
SSV_FILE="ssv.avt"
TC_FILE="tail_codes.avt"
LIB_DIR="/usr/share/avt/"
SRC=avt.rb
TARGET=avt
BINDIR=/usr/local/bin
MANDIR=/usr/local/share/man/man1
DIST_DIR=avt
VERSION=`cat avt.rb|grep "VERSION="|cut -d '"' -f2`
MANSRC=man/${TARGET}.man
MANTARGET=${TARGET}.1
SHELL=/bin/bash

all: help

.PHONY: install uninstall dist clean

install:
	echo "installing ${TARGET} to ${BINDIR}"
	mkdir -p ${DESTDIR}${LIB_DIR}
	mkdir -p ${DESTDIR}${BINDIR}
	cp -p ${SRC} ${DESTDIR}${BINDIR}/${TARGET}
	chmod 555 ${BINDIR}/${TARGET}
	cp -p ${AC_FILE} ${DESTDIR}${LIB_DIR}
	cp -p ${GEO_FILE} ${DESTDIR}${LIB_DIR}
	cp -p ${ICAO_IATA_FILE} ${DESTDIR}${LIB_DIR}
	cp -p ${SSV_FILE} ${DESTDIR}${LIB_DIR}
	cp -p ${TC_FILE} ${DESTDIR}${LIB_DIR}
	chmod 444 ${DESTDIR}${LIB_DIR}${AC_FILE}
	chmod 444 ${DESTDIR}${LIB_DIR}${GEO_FILE}
	chmod 444 ${DESTDIR}${LIB_DIR}${ICAO_IATA_FILE}
	chmod 444 ${DESTDIR}${LIB_DIR}${SSV_FILE}
	chmod 444 ${DESTDIR}${LIB_DIR}${TC_FILE}
	mkdir -p ${DESTDIR}${MANDIR}
	cp -p ${MANSRC} ${DESTDIR}${MANDIR}/${MANTARGET}
	chmod 644 ${DESTDIR}${MANDIR}/${MANTARGET}
	echo "DONE."

uninstall:
	echo "uninstalling avt from system…"
	rm -f ${DESTDIR}${LIB_DIR}*
	if [ -d ${DESTDIR}${LIB_DIR} ]; then rmdir ${DESTDIR}${LIB_DIR}; fi
	rm -f ${DEST_DIR}${BINDIR}/${TARGET}
	rm -f ${DESTDIR}${MANDIR}/${MANTARGET}
	echo "done."

dist:
	echo "making dist tarball…"
	mkdir ${DIST_DIR}
	cp ${SRC} ${DIST_DIR}/
	cp ${AC_FILE} ${DIST_DIR}/
	cp ${GEO_FILE} ${DIST_DIR}/
	cp ${ICAO_IATA_FILE} ${DIST_DIR}/
	cp ${SSV_FILE} ${DIST_DIR}/
	cp ${TC_FILE} ${DIST_DIR}/
	cp Makefile ${DIST_DIR}/
	mkdir -p ${DIST_DIR}/man
	cp -p ${MANSRC} ${DIST_DIR}/${MANSRC}
	COPYFILE_DISABLE=1 tar -cvzf ${TARGET}-${VERSION}.tar.gz ${DIST_DIR}/
	rm -rf ./${DIST_DIR}/*
	rmdir ${DIST_DIR}
	echo "done."

clean:
	rm -rf ./${DIST_DIR}/*
	if [ -d ${DIST_DIR} ]; then rmdir ${DIST_DIR}; fi

	
help:
	@ echo "The following targets are available"
	@ echo "help      - print this message"
	@ echo "install   - install everything"
	@ echo "uninstall - uninstall everything"
	@ echo "clean     - remove any temporary files"
	@ echo "dist      - make a dist .tar.gz tarball package"

