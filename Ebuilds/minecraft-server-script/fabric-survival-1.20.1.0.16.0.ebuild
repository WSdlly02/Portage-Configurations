EAPI=8

inherit java-pkg-2 systemd

PV_M=$(ver_cut 1-3)
PV_F=$(ver_cut 4-6)
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
FABRICDIR="/srv/fabric-survival"
S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_prepare() {
	eapply_user
}

src_install() {
	dodir /etc/fabric-survival-scripts
	exeinto /etc/fabric-survival-scripts
	doexe "${FILESDIR}"/execstop-fabric-survival.sh
	doexe "${FILESDIR}"/stop-fabric-survival.sh

	systemd_dounit "${FILESDIR}"/fabric-survival.service
	systemd_dounit "${FILESDIR}"/fabric-survival.socket
	systemd_dounit "${FILESDIR}"/listen-fabric-survival.service
	systemd_dounit "${FILESDIR}"/listen-fabric-survival.socket
	systemd_dounit "${FILESDIR}"/stop-fabric-survival.service
	systemd_dounit "${FILESDIR}"/stop-fabric-survival.timer
	# Install Fabric proper
	dodir "${FILESDIR}"
	java-pkg_jarinto "${FABRICDIR}"
	java-pkg_dojar "${PN}".jar
	fowners minecraft:minecraft "${FABRICDIR}"/"${PN}".jar
}
