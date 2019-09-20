# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils

# Short one-line description of this package.
DESCRIPTION="Insight Segmentation and Registratio Toolkit for Slicer"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/ITK/"

COMMIT="ff48670261e3bd16ee1c6f5494834f65183a98dd"

SRC_URI="https://github.com/Slicer/ITK/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="sci-medical/GDCM
		sci-libs/hdf5
		sci-libs/VTK
		dev-cpp/eigen"

RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/001-${PN}-${PV}-Change_itkMGHImageIO_repo_to_local.patch
	${FILESDIR}/002-${PN}-${PV}-Delete_eigen_library_from_targets.patch
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
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTING=OFF
		-DITK_USE_SYSTEM_JPEG=ON
		-DITK_USE_SYSTEM_GDCM=ON
		-DITK_USE_SYSTEM_HDF5=ON
		-DITK_USE_SYSTEM_EIGEN=OFF
		-DITK_INSTALL_LIBRARY_DIR=/usr/lib64
		-DITK_USE_SYSTEM_EIGEN=ON
		-DWORKDIR=${WORKDIR}
	)

	cmake-utils_src_configure
}
