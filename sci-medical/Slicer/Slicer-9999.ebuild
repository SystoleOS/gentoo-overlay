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
	dev-libs/qRestAPI
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
	${FILESDIR}/0001-COMP-Add-vtk-CommonSystem-component-as-requirement.patch
	${FILESDIR}/0002-COMP-Find-Eigen-required.patch
	${FILESDIR}/0003-COMP-Adapt-to-new-qRestAPI-cmake.patch
	${FILESDIR}/0004-ENH-Make-optional-the-use-of-Slicer-ITK.patch
	${FILESDIR}/0005-ENH-Remove-conditional-code-for-old-VTK.patch
	${FILESDIR}/0006-ENH-Limit-CPack-on-non-superbuild-mode.patch
	${FILESDIR}/0007-ENH-Install-testing-data-only-with-testing-support.patch
	${FILESDIR}/0008-ENH-Remove-the-App-real-suffix-from-Slicer-executabl.patch
	${FILESDIR}/0009-ENH-Use-CMake-GNUInstallDirs-in-Slicer-directories.patch
	${FILESDIR}/0010-ENH-Use-slicer-installation-dirs-for-base-dev-compon.patch
	${FILESDIR}/0011-ENH-Add-variable-install-dirs-for-Libs-dev-files.patch
	${FILESDIR}/0012-ENH-Generate-and-Install-SlicerConfig-install-tree.patch
	${FILESDIR}/0013-ENH-Make-installed-CMake-files-available.patch
	${FILESDIR}/0014-ENH-Add-CTK-as-requirement-in-UseSlicer.cmake.patch
	${FILESDIR}/0015-ENH-Add-vtkAddon-as-a-requirement-in-UseSlicer.cmake.patch
	${FILESDIR}/0016-ENH-Remove-extension-launcher-cmake-code-from-UseSli.patch
	${FILESDIR}/0017-ENH-Installation-and-setup-qSlicerExport.h.in.patch
	${FILESDIR}/0018-ENH-Add-templates-infrastructure.patch
	${FILESDIR}/0019-ENH-Update-SlicerInstallConfig.patch
	${FILESDIR}/0020-ENH-Enable-installation-of-SLicerBase-header-files.patch
	${FILESDIR}/0021-ENH-Fix-qt-loadable-modules-installation-dirs.patch
	${FILESDIR}/0022-ENH-Provide-an-install-version-ov-vtkSlicerConfigure.patch
	${FILESDIR}/0023-ENH-Update-Slicer-build-macros.patch
	${FILESDIR}/test.patch
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
		-DSlicer_DONT_USE_EXTENSION:BOOL=ON
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
		-DSlicer_USE_SlicerITK:BOOL=OFF
		-DSlicer_USE_SimpleITK:BOOL=OFF
		-DSlicer_VTK_RENDERING_BACKEND:STRING="OpenGL2"
		-DSlicer_VTK_VERSION_MAJOR:STRING="9"
		-DSlicer_INSTALL_DEVELOPMENT:BOOL=ON
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-DTeem_DIR:STRING="/usr/lib64"
		-DCTK_INSTALL_QTPLUGIN_DIR:STRING="/usr/lib64/qt5/plugins"
		-DQT_PLUGINS_DIR:STRING="/usr/lib64/designer"
		-DSlicer_QtPlugins_DIR:STRING="/usr/lib64/designer"
		-DjqPlot_DIR:STRING="/usr/share/jqPlot"
		-DSlicer_VTK_WRAP_HIERARCHY_DIR:STRING="${BUILD_DIR}"
		-DSlicer_BUILD_vtkAddon:BOOL=OFF
	)

	if use sitk; then
		mycmakeargs+=(-DSlicer_USE_SimpleITK:BOOL=ON)
	fi

	cmake_src_configure
}

src_install(){

	cmake_src_install

	# insinto /etc/Slicer
	# doins ${FILESDIR}/SlicerLauncherSettings.ini
}
