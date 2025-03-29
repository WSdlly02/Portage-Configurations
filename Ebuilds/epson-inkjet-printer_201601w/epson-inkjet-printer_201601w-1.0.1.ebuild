# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm autotools

MY_PN=${PN%_*}-${PN##*_}

DESCRIPTION="Epson printer driver (L110, L210, L300, L350, L355, L550, L555)"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX
	http://www.openprinting.org/driver/epson-201601w"
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/15/66/51/1046e0a9f8d8ec892806a8d4921335cf6f5fd1ea/${MY_PN}-${PV}-1.src.rpm"
S="${WORKDIR}/epson-inkjet-printer-filter-1.0.2"
LICENSE="LGPL-2.1 EPSON"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="net-print/cups
	app-text/ghostscript-gpl"
DEPEND="${RDEPEND}"

QA_PREBUILT="
	/opt/epson-inkjet-printer-201601w/lib64/libEpson_201601w.MT.so.1.0.1
	/opt/epson-inkjet-printer-201601w/lib64/libEpson_201601w.so.1.0.1"

src_prepare() {
	eautoreconf
	chmod +x configure
	eapply_user
}

src_configure() {
	econf LDFLAGS="$LDFLAGS -Wl,--no-as-needed" --prefix=/opt/${MY_PN}
	# if you have runtime problems:
	# add "--enable-debug" and look into /tmp/epson-inkjet-printer-filter.txt
}

src_install() {
	insinto /opt/${MY_PN}/cups/lib/filter
	doins src/epson_inkjet_printer_filter
	chmod 755 "${D}/opt/${MY_PN}/cups/lib/filter/epson_inkjet_printer_filter"
	use amd64 && X86LIB=64

	insinto /opt/${MY_PN}
	for folder in lib"${X86LIB}" resource watermark; do
		doins -r ../${MY_PN}-${PV}/$folder
	done

	insinto /usr/share/cups/model/${MY_PN}
	doins ../${MY_PN}-${PV}/ppds/*

	dodoc "AUTHORS" "COPYING" "COPYING.LIB" "COPYING.EPSON"
	dodoc ../${MY_PN}-${PV}/{Manual.txt,README}
	# Fix Step
	insinto /usr/libexec/cups/filter
	doins src/epson_inkjet_printer_filter
	chmod 755 "${D}/usr/libexec/cups/filter/epson_inkjet_printer_filter"
	use amd64 && X86LIB=64
}
