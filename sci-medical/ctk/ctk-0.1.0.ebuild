# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=8

PYTHON_COMPAT=( python3_{9,10})

inherit python-single-r1 cmake

# Short one-line description of this package.
DESCRIPTION="A set of common support code for medical imaging, surgical navigation, and related purposes"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.commontk.org/"

COMMIT="95dac75b80562b81db10555db5807648f4d17dee"

SRC_URI="https://github.com/commontk/CTK/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

IUSE="python DICOM"

DEPEND="
	python? (
		dev-python/PythonQt_CTK
		sci-libs/vtk:=[python,qt5,rendering] )
	!python? ( sci-libs/vtk:=[qt5,rendering] )
	dev-qt/designer
	dev-qt/qtconcurrent
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtmultimedia
	dev-qt/qtnetwork
	dev-qt/qtopengl
	dev-qt/qtsql
	dev-qt/qttest
	dev-qt/qtwidgets
	dev-qt/qtxmlpatterns
	dev-qt/qtxml
	sci-libs/itk[DICOM?]
"

RDEPEND="
	${DEPEND}
	python? ( ${PYTHON_DEPS} )
"

BDEPEND="
	app-arch/unzip
	${RDEPEND}
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	${FILESDIR}/0001-ENH-Include-missing-files.patch
	${FILESDIR}/0002-ENH-Change-installation-path-for-python-wrapped-file.patch
	${FILESDIR}/0003-ENH-Include-missing-ctkFunctionExtractOptimizedLibra.patch
	${FILESDIR}/0004-ENH-Make-use-of-CMake-GNUInstallDirs-module.patch
	${FILESDIR}/0005-ENH-Enable-more-selective-installation-of-python-fil.patch
	${FILESDIR}/0006-ENH-Modernize-Python-detection.patch
	${FILESDIR}/0007-ENH-Remove-installation-step-from-ctkMacroCompilePyt.patch
)

src_unpack() {
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi

	mv ${WORKDIR}/CTK-${COMMIT} ${WORKDIR}/${PN}-${PV} || die
}


pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DCTK_QT_VERSION=5
		-DBUILD_TESTING=OFF
		-DCTK_BUILD_QTDESIGNER_PLUGINS=ON
		-DCTK_BUILD_SHARED_LIBS=ON
		-DCTK_ENABLE_DICOM:BOOL=$(usex DICOM ON OFF)
		-DCTK_ENABLE_PluginFramework=OFF
		-DCTK_ENABLE_Widgets=ON
		-DCTK_LIB_Core=ON
		-DCTK_LIB_ImageProcessing/ITK/Core=ON
		-DCTK_LIB_Visualization/VTK/Core=ON
		-DCTK_LIB_Visualization/VTK/Widgets=ON
		-DCTK_LIB_Visualization/VTK/Widgets_USE_TRANSFER_FUNCTION_CHARTS=ON
		-DCTK_SUPERBUILD=OFF
		-DCTK_INSTALL_LIB_DIR:STRING=$(get_libdir)
		-DCTK_INSTALL_QTPLUGIN_DIR:STRING="$(get_libdir)/qt5/plugins"
		# PythonQt wrapping
		-DCTK_LIB_Scripting/Python/Core:BOOL="$(usex python ON OFF)"
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_USE_VTK:BOOL="$(usex python ON OFF)"
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTCORE:BOOL="$(usex python ON OFF)"
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTGUI:BOOL="$(usex python ON OFF)"
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTUITOOLS:BOOL="$(usex python ON OFF)"
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTNETWORK:BOOL="$(usex python ON OFF)"
		-DCTK_LIB_Scripting/Python/Core_PYTHONQT_WRAP_QTWEBKIT:BOOL="$(usex python ON OFF)"
		-DCTK_LIB_Scripting/Python/Widgets:BOOL="$(usex python ON OFF)"
		-DCTK_ENABLE_Python_Wrapping:BOOL="$(usex python ON OFF)"
	)

	if use python; then
	   mycmakeargs+=(
		   -DPython3_INCLUDE_DIR:FILEPATH="$(python_get_includedir)"
		   -DPython3_LIBRARY:FILEPATH="$(python_get_library_path)"
		   -DPython3_EXECUTABLE:FILEPATH="${PYTHON}"
	   )
	fi

	cmake_src_configure
}
