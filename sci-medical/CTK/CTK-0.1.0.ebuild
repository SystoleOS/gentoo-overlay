# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils

# Short one-line description of this package.
DESCRIPTION="A set of common support code for medical imaging, surgical navigation, and related purposes"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.commontk.org/"

COMMIT="20a9195338ad3b84402fc7058f9d049189280912"

SRC_URI="https://github.com/commontk/CTK/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="
	dev-qt/qtconcurrent
	dev-qt/qtcore
	dev-qt/designer
	dev-qt/qtgui
	dev-qt/qtnetwork
	dev-qt/qtopengl
	dev-qt/qtsql
	dev-qt/qttest
	dev-qt/qtwidgets
	dev-qt/qtxmlpatterns
	dev-qt/qtxml
	sci-libs/ITK
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/001-${PN}-${PV}-include_missing_files.patch
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
		-DCTK_QT_VERSION=5
		-DBUILD_TESTING=OFF
		-DCTK_BUILD_QTDESIGNER_PLUGINS=ON
		-DCTK_BUILD_SHARED_LIBS=ON
		-DCTK_ENABLE_DICOM=OFF
		-DCTK_ENABLE_PluginFramework=OFF
		-DCTK_ENABLE_Python_Wrapping=OFF
		-DCTK_ENABLE_Widgets=ON
		-DCTK_LIB_Core=ON
		-DCTK_LIB_ImageProcessing/ITK/Core=ON
		-DCTK_LIB_Visualization/VTK/Core=ON
		-DCTK_LIB_Visualization/VTK/Widgets=ON
		-DCTK_LIB_Visualization/VTK/Widgets_USE_TRANSFER_FUNCTION_CHARTS=ON
		-DCTK_SUPERBUILD=OFF
		-DCTK_INSTALL_LIB_DIR=/lib64
	)

	cmake-utils_src_configure
}
