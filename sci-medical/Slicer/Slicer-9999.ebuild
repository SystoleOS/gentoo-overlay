# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="Open source medical image processing and visualization software"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="main"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"
LICENSE="BSD"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"

IUSE="python cli DICOM"

DEPEND="
	sci-medical/ctk[python?,DICOM?]
	sci-libs/vtkAddon[python?]
	dev-qt/qtcore:5
	dev-qt/linguist-tools:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtx11extras:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5
	dev-qt/qtwebchannel:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/designer:5
	dev-libs/rapidjson
	dev-libs/jsoncpp
	dev-libs/qRestAPI
	sci-medical/CTKAppLauncherLib
	sci-medical/teem
	cli? ( Slicer-CLI/SlicerExecutionModel )
	sci-libs/itk[vtkglue,deprecated]
	sci-libs/vtk:0=
"

RDEPEND="
	${DEPEND}
	python? (
		${PYTHON_DEPS}
		dev-python/scipy
		dev-python/numpy
		)
"

# NOTE: This is due to incompatibilities with some versions of cmake
# for reference see https://github.com/Slicer/Slicer/pull/6852
BDEPEND="<dev-util/cmake-3.25"

REQUIRED_USE="
	python? (
		${PYTHON_REQUIRED_USE}
		)
"

PATCHES=(
	"${FILESDIR}/0001-COMP-Add-vtk-CommonSystem-component-as-requirement.patch"
	"${FILESDIR}/0002-COMP-Find-Eigen-required.patch"
	"${FILESDIR}/0003-COMP-Adapt-to-new-qRestAPI-cmake.patch"
	"${FILESDIR}/0004-ENH-Make-optional-the-use-of-Slicer-ITK.patch"
	"${FILESDIR}/0005-ENH-Remove-conditional-code-for-old-VTK.patch"
	"${FILESDIR}/0006-ENH-Limit-CPack-on-non-superbuild-mode.patch"
	"${FILESDIR}/0007-ENH-Install-testing-data-only-with-testing-support.patch"
	# NOTE: This should be neede further down the road
	#"${FILESDIR}/0008-ENH-Remove-the-App-real-suffix-from-Slicer-executabl.patch"
	"${FILESDIR}/0009-ENH-Use-CMake-GNUInstallDirs-in-Slicer-directories.patch"
	"${FILESDIR}/0010-ENH-Use-slicer-installation-dirs-for-base-dev-compon.patch"
	"${FILESDIR}/0011-ENH-Add-variable-install-dirs-for-Libs-dev-files.patch"
	"${FILESDIR}/0012-ENH-Generate-and-Install-SlicerConfig-install-tree.patch"
	"${FILESDIR}/0013-ENH-Make-installed-CMake-files-available.patch"
	"${FILESDIR}/0014-ENH-Add-CTK-as-requirement-in-UseSlicer.cmake.patch"
	"${FILESDIR}/0015-ENH-Add-vtkAddon-as-a-requirement-in-UseSlicer.cmake.patch"
	"${FILESDIR}/0016-ENH-Remove-extension-launcher-cmake-code-from-UseSli.patch"
	"${FILESDIR}/0017-ENH-Installation-and-setup-qSlicerExport.h.in.patch"
	"${FILESDIR}/0018-ENH-Add-templates-infrastructure.patch"
	"${FILESDIR}/0019-ENH-Update-SlicerInstallConfig.patch"
	"${FILESDIR}/0020-ENH-Enable-installation-of-SLicerBase-header-files.patch"
	"${FILESDIR}/0021-ENH-Fix-qt-loadable-modules-installation-dirs.patch"
	"${FILESDIR}/0022-ENH-Provide-an-install-version-of-vtkSlicerConfigure.patch"
	"${FILESDIR}/0023-ENH-Update-Slicer-build-macros.patch"
	"${FILESDIR}/0024-ENH-Enable-installation-of-Libs-dev-files.patch"
	"${FILESDIR}/0025-ENH-Make-Testing-subdirs-subject-to-BUILD_TESTING.patch"
	"${FILESDIR}/0026-ENH-Add-python-support.patch"
	"${FILESDIR}/0027-ENH-Disable-variable-setting-in-UseSlicer.cmake.in.patch"
	"${FILESDIR}/0028-COMP-Fix-missing-QSslConfiguration-include.patch"
	"${FILESDIR}/0029-BAD-ENH-Enable-installation-of-utility-scripts.patch"
	"${FILESDIR}/0030-GOOD-ENH-Add-installation-of-generated-Qt-header-fil.patch"
	"${FILESDIR}/0031-GOOD-ENH-Enable-installation-of-resources.patch"
	"${FILESDIR}/0032-UGLY-ENH-Fix-python-wrap-conditionals.patch"
)

src_prepare() {

	cmake_src_prepare
	cp "${FILESDIR}"/FindPythonQt.cmake "${S}"/CMake
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DSlicer_SUPERBUILD:BOOL=OFF
		-DBUILD_TESTING:BOOL=OFF
		-DSlicer_BUILD_EXTENSIONMANAGER_SUPPORT:BOOL=OFF
		-DSlicer_DONT_USE_EXTENSION:BOOL=ON
		-DSlicer_BUILD_CLI_SUPPORT:BOOL=$(usex cli ON OFF)
		-DSlicer_BUILD_CLI:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="17"
		-DSlicer_REQUIRED_QT_VERSION:STRING="5"
		-DSlicer_BUILD_DICOM_SUPPORT:BOOL=$(usex DICOM ON OFF)
		-DSlicer_BUILD_ITKPython:BOOL=OFF
		-DSlicer_BUILD_QTLOADABLEMODULES:BOOL=OFF
		-DSlicer_BUILD_QTSCRIPTEDMODULES:BOOL=OFF
		-DSlicer_BUILD_QT_DESIGNER_PLUGINS:BOOL=ON
		-DSlicer_USE_CTKAPPLAUNCHER:BOOL=OFF
		-DSlicer_USE_PYTHONQT:BOOL=$(usex python ON OFF)
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
		-DSlicer_USE_SimpleITK:BOOL=OFF
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

src_install(){

	cmake_src_install
	dobin "${FILESDIR}"/Slicer

	# insinto /etc/Slicer
	# doins ${FILESDIR}/SlicerLauncherSettings.ini
}
