avt
===

###Aviation Tools

* gets metar
* gets taf
* decode iata / icao airports
* gets sunrise / sunset
* gets geo info 
* decode airline codes
* decode aircraft tail codes
* decode aircraft names

### HOWTO INSTALL
the install script runs on all POSIX systems (unix, linux, osx, ...)
open a shell, goto the correct dir and type:

```
$ sudo make install
```

or use the legacy installer: `sudo ./install.sh`

or run it directly from the local directory without installing it (**Ruby lang is needed**)

#####LICENSE
this software is distributed under GPLv2 license.

#####AUTHOR
**Fernando Iazeolla - iazasoft**

#####EXAMPLE

```
$ avt -i fco -gmf
FCO-LIRF: Rome, Leonardo da Vinci International, Italy, IT.
lat: 41.804444 long: 12.250833
sunrise: 07:40:31 sunset: 17:12:33 alt: 3m(9.8ft)
isotime: 2013-02-02 22:25:42 +0100 timezone: 1/A (dst: False)
localtime: 2 Feb 2013 22:25:42
2013/02/02 20:50
LIRF 022050Z 25025KT 9999 FEW022 BKN040 11/03 Q0992 NOSIG
2013/02/02 18:24
TAF LIRF 021700Z 0218/0324 25022G32KT 8000 SCT020 BKN060 
      TEMPO 0218/0224 4000 SHRA BKN014 
      BECMG 0223/0302 07012KT 
      BECMG 0304/0306 01020KT

```

```
$ avt --help
avt v0.1 by Fernando Iazeolla, 2013, iazasoft
OPTIONS:
--metar     -m                        get metar
--taf       -f                        get taf
--geo       -g                        get geo info
--ssv       -y   <airline code>       decode airline code
--tc        -t   <tail code>          decode tail code
--quiet     -q                        silent output
--ac        -a   <aircraft type>      decode aircraft type
--verbose   -w                        verbose output
--version   -v                        displays avt version
--help      -h                        displays this help
--apt       -i   <iata or icao code>  input airport code
--decode    -d                        get decoded metar (with -m) -dm
--coord     -c                        displays latitude and longitude
--sun       -s                        displays sunrise and sunset
--list      -l   [ac|tc|ssv|geo|apt]  displays file database
  
examples: 
avt -i fco -gmf         displays geo info, metar and taf for iata's fco station
avt --ssv ek            decode airline code
avt -i jfk --coord      print jfk's latitude and longitude
avt --list apt |grep CDG
```

#####web
[avt project page](http://github.com/elboza/avt)

####That's all falks!

```
 _____
< bye >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
