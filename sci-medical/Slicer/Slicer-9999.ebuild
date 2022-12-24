# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-any-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="3D Slicer is an open source software for medical image processing and visualization"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="main"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"

SLOT="0"

IUSE="python cli sitk"

DEPEND="
	python? ( sci-medical/ctk[python]
				sci-libs/vtkAddon[python] )
	!python? ( sci-medical/ctk
				sci-libs/vtkAddon )
	dev-qt/qtcore
	dev-qt/linguist-tools
	dev-qt/qtmultimedia[widgets]
	dev-qt/qtopengl
	dev-qt/qtsql
	dev-qt/qtxmlpatterns
	dev-qt/qtx11extras
	dev-qt/qtsvg
	dev-qt/qtwebengine
	dev-qt/qtwebchannel
    dev-qt/qtscript
	dev-qt/designer
	dev-libs/rapidjson
	dev-libs/jsoncpp
	sci-medical/CTKAppLauncherLib
	sci-medical/teem
	cli? ( Slicer-CLI/SlicerExecutionModel )
	sci-libs/itk[vtkglue,deprecated]
	sitk? ( sci-libs/SimpleITK )
	>=sci-libs/vtk-9.1.0[qt5,rendering,gl2ps]
"

RDEPEND="
	${DEPEND}
	python? ( ${PYTHON_DEPS} )
"

BDEPEND=">=dev-util/cmake-3.23.1"


PATCHES=(
	${FILESDIR}/0001-COMP-Add-the-VTK-CommonSystem-component.patch
	${FILESDIR}/0002-Find-Eigen.patch
    ${FILESDIR}/0003-COMP-Remove-use-UseqRestAPI.patch
    ${FILESDIR}/0004-COMP-Remove-itkNamespace_h.patch
    ${FILESDIR}/0005-Add-qRestAPI-include-dir.patch
    ${FILESDIR}/0006-ENH-Enable-alternative-install-lib-directory.patch
	# ${FILESDIR}/0001-COMP-Remove-uneccessary-link-libraries-for-QTCore.patch
	# ${FILESDIR}/0002-COMP-Fix-link-libraries-in-QTGUI.patch
	# ${FILESDIR}/0003-COMP-Generate-and-Install-SlicerConfig-install-tree.patch
	# ${FILESDIR}/0004-COMP-Setting-CMAKE_MODULE_PATH-to-account-for-CTK-an.patch
	# ${FILESDIR}/0005-COMP-Add-installation-of-missing-files.patch
	# ${FILESDIR}/0006-COMP-Enable-install-of-development-files-in-Slicer-l.patch
	# ${FILESDIR}/0007-COMP-Adding-MRML_LIBRARIES-variable-to-install-confi.patch
	# ${FILESDIR}/0008-COMP-Change-Slicer_ROOT-by-Slicer_HOME-in-UseSlicer..patch
	# ${FILESDIR}/0009-COMP-Add-QTLOADABLEMODULES-dirs-in-intall-tree-confi.patch
	# ${FILESDIR}/0010-COMP-Adding-conditional-for-installation-of-QT-desig.patch
	# ${FILESDIR}/0011-COMP-Enable-installation-of-generated-.h-files-for-B.patch
	# ${FILESDIR}/0012-COMP-Enable-installation-of-header-files-for-qMRMLWi.patch
	# ${FILESDIR}/0013-COMP-Change-JsonCpp-by-jsoncpp.patch
	# ${FILESDIR}/0014-COMP-Adding-link-directories-for-ModuleParser.patch
	# ${FILESDIR}/0015-COMP-Change-installation-destination.patch
	# ${FILESDIR}/0016-COMP-Change-GLOB-filter-for-installing-vtkITK-dev-co.patch
	# ${FILESDIR}/0017-COMP-Add-Slicer_USE_PYTHONQT-as-condition-for-Module.patch
	# ${FILESDIR}/0018-COMP-Adding-MRMLCLI-include-directories-to-Slicer_Ba.patch
	# ${FILESDIR}/0019-COMP-Fix-install-path-for-CLI-modules.patch
	# ${FILESDIR}/0020-COMP-Fix-ITKFactoryRegistration-issues-on-install-tr.patch
	# ${FILESDIR}/0021-ENH-Enable-Python.patch
	# ${FILESDIR}/0022-COMP-Set-missing-variables-in-SlicerConfig-install-c.patch
	# ${FILESDIR}/0023-COMP-Add-needed-include-dirs-for-python-wrapping-of-.patch
	# ${FILESDIR}/0024-ENH-Make-available-paths-to-installed-qt-loadable-mo.patch
	# ${FILESDIR}/0025-ENH-Enable-installation-of-hierarchy-files-.txt-for-.patch
	# ${FILESDIR}/0026-ENH-Change-SlicerApp-real-Slicer.patch
	# ${FILESDIR}/0027-ENH-Enable-search-of-settings-in-etc-Slicer-for-ints.patch
	# ${FILESDIR}/0028-ENH-Improve-directories-configuration.patch
	# ${FILESDIR}/0029-COMP-Add-finding-of-vtkAddon-and-mod-on-Slicer_Libs_.patch
	# ${FILESDIR}/0030-ENH-Adding-ModuleWizard.py-to-the-list-of-scripts-co.patch
)

src_prepare() {

	cmake_src_prepare
	cp ${FILESDIR}/FindPythonQt.cmake ${S}/CMake
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DSlicer_SUPERBUILD:BOOL=OFF
		-DBUILD_TESTING:BOOL=OFF
		-DSlicer_BUILD_EXTENSIONMANAGER_SUPPORT:BOOL=OFF
		-DSlicer_BUILD_CLI_SUPPORT:BOOL="$(usex cli)"
		-DSlicer_BUILD_CLI:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="17"
		-DSlicer_REQUIRED_QT_VERSION:STRING="5"
		-DSlicer_BUILD_DICOM_SUPPORT:BOOL=OFF
		-DSlicer_BUILD_ITKPython:BOOL=OFF
		-DSlicer_BUILD_QTLOADABLEMODULES:BOOL=OFF
		-DSlicer_BUILD_QTSCRIPTEDMODULES:BOOL=OFF
		-DSlicer_BUILD_QT_DESIGNER_PLUGINS:BOOL=ON
		-DSlicer_USE_CTKAPPLAUNCHER:BOOL=OFF
		-DSlicer_USE_PYTHONQT:BOOL="$(usex python)"
		-DSlicer_USE_QtTesting:BOOL=OFF
		-DSlicer_USE_SimpleITK:BOOL=OFF
		-DSlicer_VTK_RENDERING_BACKEND:STRING="OpenGL2"
		-DSlicer_VTK_VERSION_MAJOR:STRING="9"
		-DSlicer_INSTALL_DEVELOPMENT:BOOL=ON
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-DTeem_DIR:STRING="/usr/lib64"
		-DCTK_INSTALL_QTPLUGIN_DIR:STRING="/usr/lib64/qt5/plugins"
		-DQT_PLUGINS_DIR:STRING="/usr/lib64/designer"
		-DSlicer_QtPlugins_DIR:STRING="/usr/lib64/designer"
		-DSlicer_LIB_PREFIX:STRING="lib64"
		-DSlicer_INSTALL_PYTHOND_LIB_DIR:STRING="$(get_libdir)"
		-DSlicer_INSTALL_PYTHON_LIB_DIR:STRING="$(python_get_sitedir)"
		-DSlicer_INSTALL_PYTHON_BIN_DIR:STRING="$(python_get_sitedir)"
		-DSlicer_INSTALL_BIN_DIR:STRING="bin"
		-DjqPlot_DIR:STRING="/usr/share/jqPlot"
		-DCTKAppLauncherLib_DIR:STRING="/usr/lib64/CTKAppLauncher-1.0.0"
		-DSlicer_VTK_WRAP_HIERARCHY_DIR:STRING="${BUILD_DIR}"
		-DSlicer_INSTALL_QTLOADABLEMODULES_BIN_DIR:STRING="lib64/Slicer-5.1.0/qt-loadable-modules"
		-DSlicer_INSTALL_QTLOADABLEMODULES_LIB_DIR:STRING="lib64/Slicer-5.1.0/qt-loadable-modules"
		-DSlicer_INSTALL_QTSCRIPTEDMODULES_BIN_DIR:STRING="lib64/Slicer-5.1.0/qt-scripted-modules"
		-DSlicer_INSTALL_QTSCRIPTEDMODULES_LIB_DIR:STRING="lib64/Slicer-5.1.0/qt-scripted-modules"
		-DSlicer_INSTALL_CLIMODULES_BIN_DIR:STRING="lib64/Slicer-5.1.0/cli-modules"
		-DSlicer_INSTALL_CLIMODULES_LIB_DIR:STRING="lib64/Slicer-5.1.0/cli-modules"
		-DSlicer_INSTALL_LIBEXEC_DIR:STRING="lib64/Slicer-5.1.0/libexec"
		-DSlicer_INSTALL_CMAKE_CONFIG_DIR:STRING="lib64/cmake/Slicer"
		-DSlicer_INSTALL_CMAKE_DIR:STRING="lib64/Slicer-5.1.0/CMake"
		-DSlicer_INSTALL_SHARE_DIR:STRING="share/Slicer-5.1.0"
		-DSlicer_INSTALL_LIBEXEC_DIR:STRING="/usr/bin"
		-DSlicer_INSTALL_ITKFACTORYREGISTRATION_INCLUDE_DIR:STRING="include/ITKFactoryRegistration"
		-DSlicer_BUILD_vtkAddon:BOOL=OFF
	)

	if use sitk; then
		mycmakeargs+=(-DSlicer_USE_SimpleITK:BOOL=ON)
	fi

	cmake_src_configure
}

src_install(){

	cmake_src_install

	insinto /etc/Slicer
	doins ${FILESDIR}/SlicerLauncherSettings.ini
}
