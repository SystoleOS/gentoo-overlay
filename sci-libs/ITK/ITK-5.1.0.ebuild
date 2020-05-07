# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils

# Short one-line description of this package.
DESCRIPTION="Insight Segmentation and Registratio Toolkit for Slicer"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/ITK/"

COMMIT="35704a458d1ad9a4a2f2634d38032216ab280823"

SRC_URI="https://github.com/InsightSoftwareConsortium/ITK/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="sci-medical/GDCM
		sci-libs/hdf5[cxx]
		sci-libs/VTK
		dev-cpp/eigen"

RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/0001-ENH-Add-MGHIO-module-as-local.patch
	${FILESDIR}/0002-COMP-Remove-ITKEigen3.patch
	${FILESDIR}/0003-ENH-Add-ITKThickness3D-as-local-module.patch
	)

src_unpack() {

	# Unpack ITK source code
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi
	mv ${WORKDIR}/${PN}-${COMMIT} ${WORKDIR}/${PN}-${PV}

	# Inject ITKImageIO remote module
	unpack ${FILESDIR}/itkMGHImageIO-master.zip
	pushd ${WORKDIR}/itkMGHImageIO || die
	git init
	popd || die

	# Inject ITKThickness3D remote module
	unpack ${FILESDIR}/ITKThickness3D.zip
	pushd ${WORKDIR}/ITKThickness3D || die
	git init
	popd || die
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
		-DModule_MGHIO=ON
		-DModule_Thickness3D=ON
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
