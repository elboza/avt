#!/bin/sh

AC_FILE="aircraft_type_decode.avt"
GEO_FILE="geo_iata.avt"
ICAO_IATA_FILE="icao_iata.avt"
SSV_FILE="ssv.avt"
TC_FILE="ssv.avt"
LIB_DIR="/usr/share/avt/"

echo "avt LEGACY installer"
echo "This installer is deprecated. Next time use 'sudo make install' instead."
if [ ! -d "/usr/share/avt" ] ; then
mkdir /usr/share/avt
fi
cp avt.rb /usr/bin/
if [ ! -f "/usr/bin/avt" ] ; then
ln -s /usr/bin/avt.rb /usr/bin/avt
fi
chmod 755 /usr/bin/avt.rb
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
echo "installed."
