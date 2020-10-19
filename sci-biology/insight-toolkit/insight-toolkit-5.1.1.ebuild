# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils

# Short one-line description of this package.
DESCRIPTION="Insight Segmentation and Registration Toolkit for Slicer"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/ITK/"

SRC_URI="https://github.com/InsightSoftwareConsortium/ITK/archive/v${PV}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="sci-medical/GDCM
		sci-libs/hdf5[cxx]
		sci-libs/vtk
		dev-cpp/eigen"

RDEPEND="${DEPEND}"

src_unpack() {

	unpack ${A}
	mv ${WORKDIR}/ITK-${PV} ${WORKDIR}/${PN}-${PV}
}

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DITK_BUILD_DEFAULT_MODULES=ON
		-DBUILD_SHARED_LIBS=ON
		-DITK_DOXYGEN_HTML=OFF
		-DITK_LEGACY_REMOVE=OFF
		-DITK_LEGACY_SILENT=ON
		-DModule_ITKReview=ON
		-DModule_ITKVtkGlue=ON
		-DModule_ITKDeprecated=ON
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTING=OFF
		-DITK_USE_SYSTEM_JPEG=ON
		-DITK_USE_SYSTEM_GDCM=ON
		-DITK_USE_SYSTEM_HDF5=ON
		-DITK_USE_SYSTEM_EIGEN=ON
		-DITK_USE_CONCEPT_CHECKING=OFF
		-DVNL_CONFIG_LEGACY_METHODS=ON
		-DITK_INSTALL_LIBRARY_DIR=/usr/lib64
		-DWORKDIR=${WORKDIR}
	)

	cmake-utils_src_configure
}
