EAPI=8

inherit java-pkg-2 systemd

PV_M=$(ver_cut 1-2)
PV_F=$(ver_cut 3-5)
DESCRIPTION="Minecraft server with the next-generation Fabric mod loader"

HOMEPAGE="https://fabricmc.net"

SRC_URI="https://meta.fabricmc.net/v2/versions/loader/${PV_M}/${PV_F}/1.0.1/server/jar -> ${P}.jar"
S="${WORKDIR}"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

ACCT_DEPEND="
	acct-group/minecraft
	acct-user/minecraft
"
BDEPEND="
	>=virtual/jdk-21
	>=virtual/jre-21
"
DEPEND="
	${ACCT_DEPEND}
	${BDEPEND}
"
RDEPEND="
	${DEPEND}
"
#RESTRICT="network-sandbox"
FABRICDIR="/srv/vanilla-survival"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_prepare() {
	eapply_user
}

src_install() {
	exeinto /usr/libexec/vanilla-survival
	dodir /usr/libexec/vanilla-survival
	doexe "${FILESDIR}"/execstop-vanilla-survival
	doexe "${FILESDIR}"/stop-vanilla-survival

	systemd_dounit "${FILESDIR}"/vanilla-survival.service
	systemd_dounit "${FILESDIR}"/vanilla-survival.socket
	systemd_dounit "${FILESDIR}"/listen-vanilla-survival.service
	systemd_dounit "${FILESDIR}"/listen-vanilla-survival.socket
	systemd_dounit "${FILESDIR}"/stop-vanilla-survival.service
	systemd_dounit "${FILESDIR}"/stop-vanilla-survival.timer
	# Install Fabric proper
	dodir "${FABRICDIR}"
	java-pkg_jarinto "${FABRICDIR}"
	mv "${PN}-${PV}.jar" "${PN}".jar
	java-pkg_dojar "${PN}".jar
	fowners minecraft:minecraft "${FABRICDIR}"/"${PN}".jar
}
