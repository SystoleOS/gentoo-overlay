# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit cmake python-single-r1

DESCRIPTION="A layer built on top of the Insight Toolkit (ITK), intended to simplify and facilitate ITK's use in rapid prototyping, education and interpreted languages."

HOMEPAGE="https://github.com/SimpleITK/SimpleITK"

SRC_URI="https://github.com/SimpleITK/SimpleITK/archive/v1.2.4.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"

DEPEND="
	dev-lang/python
	>=dev-lang/lua-5.1
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	${FILESDIR}/0001-ENH-Adding-installation-directory-for-python-module.patch
)

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
		-DBUILD_TESTING:BOOL=OFF
		-DWRAP_LUA:BOOL=OFF
		-DWRAP_JAVA:BOOL=OFF
		-DWRAP_PYTHON:BOOL=ON
		-DSKBUILD:BOOL=ON
		-DSimpleITK_INSTALL_LIBRARY_DIR:STRING="$(get_libdir)"
		-DSimpleITK_INSTALL_ARCHIVE_DIR:STRING="$(get_libdir)"
		-DSimpleITK_INSTALL_PYTHON_LIBRARY_DIR:STRING="$(python_get_sitedir)"
	)

	cmake_src_configure
}
