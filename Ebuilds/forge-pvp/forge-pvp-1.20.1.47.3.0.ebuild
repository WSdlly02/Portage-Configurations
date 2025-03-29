EAPI=8

inherit java-pkg-2 systemd

PV_M=$(ver_cut 1-3)
PV_F=$(ver_cut 4-6)
FIN_PV="${PV_M}-${PV_F}"
DESCRIPTION="Minecraft server with Forge mod loader"

HOMEPAGE="https://fabricmc.net"

SRC_URI="https://maven.minecraftforge.net/net/minecraftforge/forge/${FIN_PV}/forge-${FIN_PV}-installer.jar -> ${P}.jar"
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
RESTRICT="network-sandbox"
FORGEDIR="/srv/forge-pvp"
JVM_OPTS="-Xmx3072M -Xms3072M -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000 -XX:+UseVectorCmov -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1 -XX:AllocatePrefetchStyle=3  -XX:+UseG1GC -XX:MaxGCPauseMillis=37 -XX:+PerfDisableSharedMem -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=23 -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:G1MixedGCCountTarget=3 -XX:G1HeapWastePercent=20 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5.0 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:GCTimeRatio=99 -XX:+UseLargePages -XX:LargePageSizeInBytes=2m"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
}

src_prepare() {
	java -Duser.home="${S}" -jar ${PN}-${PV}.jar nogui --installServer
	eapply_user
}

src_install() {
	exeinto /usr/libexec/forge-pvp
	dodir /usr/libexec/forge-pvp
	doexe "${FILESDIR}"/execstop-forge-pvp
	doexe "${FILESDIR}"/stop-forge-pvp

	insinto "${FORGEDIR}"
	dodir "${FORGEDIR}"
	rm "${S}/"${PN}-${PV}.jar
	rm "${S}/"${PN}-${PV}.jar.log
	echo "${JVM_OPTS}" > "${S}/"user_jvm_args.txt
	doins -r "${S}/"*
	exeinto "${FORGEDIR}"
	doexe "${S}/"run.sh

	systemd_dounit "${FILESDIR}"/forge-pvp.service
	systemd_dounit "${FILESDIR}"/forge-pvp.socket
	systemd_dounit "${FILESDIR}"/listen-forge-pvp.service
	systemd_dounit "${FILESDIR}"/listen-forge-pvp.socket
	systemd_dounit "${FILESDIR}"/stop-forge-pvp.service
	systemd_dounit "${FILESDIR}"/stop-forge-pvp.timer
	fowners minecraft:minecraft -R "${FORGEDIR}"
}
