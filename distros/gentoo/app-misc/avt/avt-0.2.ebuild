# Copyright 1999-2013 Gentoo Foundation
# metar custom ebuild by xnando
# Distributed under the terms of the GNU General Public License v2
# $Header:$
	
# Please note that this file is still experimental !
#
# if you wonder how to use this ebuild :

# su
# 
# 
# mkdir -p /usr/local/portage/app-misc/avt
# cp avt-0.2.ebuild /usr/local/portage/app-misc/avt/
# cd /usr/local/portage/app-misc/avt
# ebuild  ${P}.ebuild digest
# echo PORTDIR_OVERLAY=/usr/local/portage >> /etc/make.conf
# emerge avt

DESCRIPTION="Aviation Tools: metar, taf ,iata / icao airports, sunrise / sunset, geo info, airline codes, and more..."
HOMEPAGE="http://github.com/elboza/avt"
SRC_URI="http://www.autistici.org/0xFE/software/releases/avt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/ruby"

RDEPEND=""

src_unpack() {
        unpack ${A}
        cd ${S}
}

S=${WORKDIR}/${PN}
src_install() {
    elog "installing ${P}"
	mkdir -p "${D}/usr/bin"
	cp "${S}"/avt.rb "${D}"/usr/bin/avt
	mkdir -p "${D}/usr/local/share/avt"
	cp "${S}/aircraft_type_decode.avt" "${D}/usr/local/share/"
	cp "${S}/geo_iata.avt" "${D}/usr/local/share/"
	cp "${S}/icao_iata.avt" "${D}/usr/local/share/"
	cp "${S}/ssv.avt" "${D}/usr/local/share/"
	cp "${S}/tail_codes.avt" "${D}/usr/local/share/"
}

