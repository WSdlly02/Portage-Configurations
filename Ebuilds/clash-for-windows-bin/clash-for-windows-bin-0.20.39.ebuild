# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg-utils

DESCRIPTION="A Windows/macOS/Linux GUI based on Clash and Electron."
HOMEPAGE="https://github.com/Fndroid/clash_for_windows_pkg"
SRC_URI="
	amd64? ( https://web.archive.org/web/20231020093608if_/https://objects.githubusercontent.com/github-production-release-asset-2e65be/153697551/c6e9c14e-0049-4e02-8ea5-12d8fabf9f9d?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20231020%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20231020T093608Z&X-Amz-Expires=300&X-Amz-Signature=f07dabe509fbcb04ed7d0491a41bce68417ce24f04792124b300344c623114b4&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=153697551&response-content-disposition=attachment%3B%20filename%3DClash.for.Windows-${PV}-x64-linux.tar.gz&response-content-type=application%2Foctet-stream -> ${P}.tar.gz )
	arm64? ( https://web.archive.org/web/20231020093527if_/https://objects.githubusercontent.com/github-production-release-asset-2e65be/153697551/b1e7558e-9fa3-4ccc-b2f6-d0ff6cc5b34a?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20231020%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20231020T093527Z&X-Amz-Expires=300&X-Amz-Signature=4942053a395a115dcea01b4ee9854fc57a01b0d5ebf8eab99b0933a29e155f12&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=153697551&response-content-disposition=attachment%3B%20filename%3DClash.for.Windows-${PV}-arm64-linux.tar.gz&response-content-type=application%2Foctet-stream -> ${P}.tar.gz )
"
LICENSE="no-source-code"
S="${WORKDIR}"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+tun"

RESTRICT="mirror"

QA_PRESTRIPPED="*"
QA_PREBUILT="*"

RDEPEND="
	x11-libs/gtk+:3
	x11-libs/libXScrnSaver
	dev-libs/nss
	tun? ( net-firewall/nftables )"

src_configure() {
	mv "${S}"/Clash\ for\ Windows-"${PV}"-* "${S}/${PN}"
}

src_install() {
	insinto "/opt"
	doins -r "${S}/${PN}"
	doicon -s 512 "${FILESDIR}/${PN}.png"
	domenu "${FILESDIR}/${PN}.desktop"
	dosym -r "/opt/${PN}/cfw" "/usr/bin/cfw"
	fperms 0755 "/opt/${PN}" -R
}

pkg_postinst() {
	xdg_icon_cache_update
}
