# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake

# Short one-line description of this package.
DESCRIPTION="Implementation of the DICOM standard"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://gdcm.sourceforge.net/"

SRC_URI="https://sourceforge.net/projects/gdcm/files/gdcm%202.x/GDCM%202.8.8/gdcm-2.8.8.tar.gz/download -> ${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="
	media-libs/openjpeg
	dev-libs/libxml2
	sys-libs/zlib
	app-text/poppler
	dev-libs/openssl
	sci-libs/dcmtk
"
RDEPEND="${DEPEND}"

PATCHES=( )

src_unpack() {
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi

	mv ${WORKDIR}/gdcm-${PV} ${WORKDIR}/${PN}-${PV}
}

src_prepare() {

	cmake_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DGDCM_BUILD_DOCBOOK_MANPAGES=OFF
		-DGDCM_BUILD_APPLICATIONS=OFF
		-DGDCM_BUILD_EXAMPLES=OFF
		-DGDCM_BUILD_SHARED_LIBS=ON
		-DGDCM_BUILD_TESTING=0FF
		-DGDCM_USE_VTK=OFF
		-DGDCM_USE_SYSTEM_OPENJPEG=ON
		-DGDCM_INSTALL_LIB_DIR=lib64
	)

	cmake_src_configure
}
