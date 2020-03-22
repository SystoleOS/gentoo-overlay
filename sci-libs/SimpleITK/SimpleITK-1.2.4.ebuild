# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit cmake-utils

DESCRIPTION="A layer built on top of the Insight Toolkit (ITK), intended to simplify and facilitate ITK's use in rapid prototyping, education and interpreted languages."

HOMEPAGE="https://github.com/SimpleITK/SimpleITK"

SRC_URI="https://github.com/SimpleITK/SimpleITK/archive/v1.2.4.zip -> ${PN}-${PV}.zip"

LICENSE="Apache 2.0"
KEYWORDS="~amd64"
SLOT="0"

DEPEND="
	dev-lang/python
	>=dev-lang/lua-5.1
"
RDEPEND="${DEPEND}"

PATCHES=(${FILESDIR}/test.patch)

src_unpack() {

	# Unpack ITK source code
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi
	mv ${WORKDIR}/${PN}-${COMMIT} ${WORKDIR}/${PN}-${PV}
}

src_configure() {

	local mycmakeargs=()

	# General building options
	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DWRAP_LUA=OFF
		-DWRAP_JAVA=OFF
		-DWRAP_PYTHON=ON
		-DSKBUILD=ON
		-DSimpleITK_INSTALL_LIBRARY_DIR=lib64
		-DSimpleITK_INSTALL_ARCHIVE_DIR=lib64
		-DSimpleITK_INSTALL_PREFIX=/usr
	)

	cmake-utils_src_configure
}

pkg_postinst(){

	ln -sf /usr/lib64/SimpleITK/ /usr/lib64/python3.6/site-packages/SimpleITK || die
}
