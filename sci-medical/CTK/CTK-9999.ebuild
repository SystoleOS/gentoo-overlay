# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils git-r3

# Short one-line description of this package.
DESCRIPTION="A set of common support code for medical imaging, surgical navigation, and related purposes"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.commontk.org/"

COMMIT="20a9195338ad3b84402fc7058f9d049189280912"

#SRC_URI="https://github.com/commontk/CTK/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

EGIT_REPO_URI="https://github.com/commontk/CTK"
EGIT_BRANCH="master"

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
	#"${FILESDIR}"/001-${PN}-${PV}-include_missing_files.patch
	#	"${FILESDIR}"/002-${PN}-${PV}-Remove_ITK_libraries_as_target.patch
	${FILESDIR}/003-Add-utility-files-for-PythonQt.patch
)

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
		-DCTK_ENABLE_Widgets=ON
		-DCTK_LIB_Core=ON
		-DCTK_LIB_ImageProcessing/ITK/Core=ON
		-DCTK_LIB_Visualization/VTK/Core=ON
		-DCTK_LIB_Visualization/VTK/Widgets=ON
		-DCTK_LIB_Visualization/VTK/Widgets_USE_TRANSFER_FUNCTION_CHARTS=ON
		-DCTK_SUPERBUILD=OFF
		-DCTK_INSTALL_LIB_DIR=/lib64
		-DCTK_LIB_Scripting/Python/Core=ON
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_USE_VTK=ON
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTCORE=ON
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTGUI=ON
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTUITOOLS=ON
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTNETWORK=ON
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTWEBKIT=OFF
		-DCTK_LIB_Scripting/Python/Widgets=ON
		-DCTK_ENABLE_Python_Wrapping=ON
	)

	cmake-utils_src_configure
}
