# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Set of libraries for representing, processing and visualizing scientific raster data (3D Slicer maintained)"

HOMEPAGE="https://teem.sourceforge.net"

SRC_URI="https://github.com/Slicer/teem/archive/e4746083c0e1dc0c137124c41eca5d23adf73bfa.zip -> ${P}.zip"

LICENSE="LGPL-2.1"

KEYWORDS="~amd64"

SLOT="0"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(

	${FILESDIR}/0002-ENH-Remove_creation_of_TeemLibraryDepends_cmake.patch
	${FILESDIR}/0001-ENH-Fix_install_when_TEEM_LIB_INSTALL_DIR_is_set.patch
	${FILESDIR}/test.patch
)

src_unpack(){

	default

	mv ${WORKDIR}/* ${WORKDIR}/${P}
}

src_configure() {

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=OFF
		-DTeem_LIB_INSTALL_DIR=$(get_libdir)
	)

	cmake_src_configure
}
