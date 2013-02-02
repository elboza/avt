#!/bin/sh

echo "avt installer"
if [ ! -d "/usr/share/avt" ] ; then
mkdir /usr/share/avt
fi
cp avt.rb /usr/bin/
if [ ! -f "/usr/bin/avt" ] ; then
ln -s /usr/bin/avt.rb /usr/bin/avt
fi
chmod 755 /usr/bin/avt.rb
cp aircraft_type_decode.txt /usr/share/avt/
cp geo_iata.txt /usr/share/avt/
cp icao_iata.txt /usr/share/avt/
cp ssv.txt /usr/share/avt/
cp tail_codes.txt /usr/share/avt/
chmod 444 /usr/share/avt/aircraft_type_decode.txt
chmod 444 /usr/share/avt/geo_iata.txt
chmod 444 /usr/share/avt/icao_iata.txt
chmod 444 /usr/share/avt/ssv.txt
chmod 444 /usr/share/avt/tail_codes.txt

