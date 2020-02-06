# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit multibuild python-r1 qmake-utils cmake-utils

# Short one-line description of this package.
DESCRIPTION="A set of common support code for medical imaging, surgical navigation, and related purposes"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.commontk.org/"

COMMIT="20a9195338ad3b84402fc7058f9d049189280912"

SRC_URI="https://github.com/commontk/CTK/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE="python"


RDEPEND="
	python? ( ${PYTHON_DEPS}
			  dev-python/PythonQt_CTK
			  sci-libs/VTK[python] )
	!python? ( sci-libs/VTK )
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
DEPEND="${RDEPEND}"

PATCHES=(
	${FILESDIR}/0001-ENH-Include-missing-files.patch
	${FILESDIR}/0002-ENH-Change-installation-path-for-python-wrapped-file.patch
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

	configure() {

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
			-DCTK_INSTALL_LIB_DIR=/usr/lib64
			# PythonQt wrapping
			-DCTK_LIB_Scripting/Python/Core:BOOL="$(usex python)"
			-DCTK_LIB_Scripting/Python/Core_PYTHONQT_USE_VTK:BOOL="$(usex python)"
			-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTCORE:BOOL="$(usex python)"
			-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTGUI:BOOL="$(usex python)"
			-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTUITOOLS:BOOL="$(usex python)"
			-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTNETWORK:BOOL="$(usex python)"
			-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTWEBKIT:BOOL="$(usex python)"
			-DCTK_LIB_Scripting/Python/Widgets:BOOL="$(usex python)"
			-DCTK_ENABLE_Python_Wrapping:BOOL="$(usex python)"
		)

		if use python;then
			mycmakeargs+=(-DPYTHON_SITE_DIR=$(python_get_sitedir))
		fi

		cmake-utils_src_configure
	}

	python_foreach_impl run_in_build_dir configure
}
