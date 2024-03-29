# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake

DESCRIPTION="Scientific raster data processing and visualization libraries"

HOMEPAGE="https://teem.sourceforge.net"

SRC_URI="https://github.com/Slicer/teem/archive/e4746083c0e1dc0c137124c41eca5d23adf73bfa.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-Fix-install-when-TEEM_LIB_INSTALL_DIR-is-set.patch"
	"${FILESDIR}/0002-Remove-creation-of-TeemLibraryDepends.cmake.patch"
	"${FILESDIR}/0003-Replace-TEEM-by-Teem-in-CMake-variables.patch"
	"${FILESDIR}/0004-Change-CMake-files-installation-path.patch"
	"${FILESDIR}/0005-Modify-INSTALL_RPATH-and-INSTALL_NAME_DIR-for-instal.patch"
)

src_unpack(){

	default

	mv "${WORKDIR}"/* "${WORKDIR}"/"${P}"
}

src_configure() {

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=OFF
		-DTeem_LIB_INSTALL_DIR:STRING="$(get_libdir)"
		-DTeem_SHARE_INSTALL_DIR:STRING="/usr/share"
	)

	cmake_src_configure
}
