# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 git-r3

DESCRIPTION="Linux kernel driver for reading sensors of AMD Zen family CPUs"
HOMEPAGE="https://github.com/BoukeHaarsma23/zenergy"
EGIT_REPO_URI="https://github.com/BoukeHaarsma23/zenergy.git"
EGIT_BRANCH="master"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	!sys-kernel/zenpower
	!sys-kernel/zenpower3
"

CONFIG_CHECK="HWMON PCI AMD_NB"

src_compile() {
	local modlist=(
		zenergy
	)
	local modargs=( TARGET="${KV_FULL}" KERNEL_BUILD="${KV_OUT_DIR}" )
	linux-mod-r1_src_compile
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
}
