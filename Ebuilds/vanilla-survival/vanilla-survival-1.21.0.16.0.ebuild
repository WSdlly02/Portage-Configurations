EAPI=8

inherit java-pkg-2 systemd

PV_M=$(ver_cut 1-2)
PV_F=$(ver_cut 3-5)
DESCRIPTION="Minecraft server with the next-generation Fabric mod loader"

HOMEPAGE="https://fabricmc.net"

SRC_URI="https://meta.fabricmc.net/v2/versions/loader/${PV_M}/${PV_F}/1.0.1/server/jar -> ${PN}.jar"


LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

ACCT_DEPEND="
	acct-group/minecraft
	acct-user/minecraft
"
BDEPEND="
	${ACCT_DEPEND}
	|| (
		virtual/jre:21
		virtual/jdk:21
	)
"
DEPEND="
        ${ACCT_DEPEND}
	|| (
		virtual/jre:21
		virtual/jdk:21
	)
"
RDEPEND="
	${ACCT_DEPEND}
	${DEPEND}
"
#RESTRICT="bindist network-sandbox"
FABRICDIR="/srv/vanilla-survival"
S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_prepare() {
	eapply_user
}

src_install() {
	dodir /etc/vanilla-survival-scripts
	exeinto /etc/vanilla-survival-scripts
	doexe "${FILESDIR}"/execstop-vanilla-survival.sh
	doexe "${FILESDIR}"/stop-vanilla-survival.sh

	systemd_dounit "${FILESDIR}"/vanilla-survival.service
	systemd_dounit "${FILESDIR}"/vanilla-survival.socket
	systemd_dounit "${FILESDIR}"/listen-vanilla-survival.service
	systemd_dounit "${FILESDIR}"/listen-vanilla-survival.socket
	systemd_dounit "${FILESDIR}"/stop-vanilla-survival.service
	systemd_dounit "${FILESDIR}"/stop-vanilla-survival.timer
	# Install Fabric proper
	dodir "${FILESDIR}"
	java-pkg_jarinto "${FABRICDIR}"
	java-pkg_dojar "${PN}".jar
	fowners minecraft:minecraft "${FABRICDIR}"/"${PN}".jar
}
