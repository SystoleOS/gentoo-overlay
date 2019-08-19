# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

# Short one-line description of this package.
DESCRIPTION="Insight Segmentation and Registratio Toolkit for Slicer"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/ITK/"

COMMIT="a44f430b3edb5fff62671b4ba87cf41c60ee272b"

SRC_URI="https://github.com/Slicer/ITK/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="sci-medical/gdcm
		sci-libs/hdf5
		sci-libs/VTK"
RDEPEND="${DEPEND}"

PATCHES=(
	)

src_unpack() {
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi

	mv ${WORKDIR}/${PN}-${COMMIT} ${WORKDIR}/${PN}-${PV}
}

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DITK_BUILD_DEFAULT_MODULES=ON
		-DITK_DOXYGEN_HTML=OFF
		-DITK_LEGACY_REMOVE=ON
		-DITK_LEGACY_SILENT=ON
		-DModule_ITKReview=ON
		-DModule_ITKVtkGlue=ON
		-DModule_MGHIO=ON
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTING=OFF
		-DITK_USE_SYSTEM_JPEG=ON
		-DITK_USE_SYSTEM_GDCM=ON
		-DITK_USE_SYSTEM_HDF5=ON
	)

	cmake-utils_src_configure
}
