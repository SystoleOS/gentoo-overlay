# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils multilib git-r3

# Short one-line description of this package.
DESCRIPTION="3D Slicer is an open source software platform for medical image informatics,
image processing, and three-dimensional visualization. This package is a
live-build which will pull the master branch of the official 3D Slicer repository."

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="master"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtcore
	dev-qt/qtmultimedia
	dev-qt/qtopengl
	dev-qt/qtsql
	dev-qt/qtxmlpatterns
	dev-qt/qtwebengine
	dev-qt/qtwebchannel
	dev-qt/designer
	dev-libs/rapidjson
	dev-libs/jsoncpp
	sci-medical/CTK
	sci-medical/CTKAppLauncherLib
"

RDEPEND="${DEPEND}"

PATCHES=(
#	${FILESDIR}/0001-COMP-Remove-uneccessary-link-libraries-for-QTCore.patch
#	${FILESDIR}/0002-COMP-Fix-link-libraries-in-QTGUI.patch
#	${FILESDIR}/0003-COMP-Enable-Slicer_INSTALL_DEVELOPMENT-option.patch
#	${FILESDIR}/0004-COMP-Fix-path-for-slicer-installation-headers.patch
#	${FILESDIR}/0005-COMP-Adding-conditional-for-including-python-testing.patch
#	${FILESDIR}/0006-COMP-Change-path-for-installing-qSlicerUtilsTest1.cx.patch
#	${FILESDIR}/0007-COMP-Generate-and-Install-SlicerConfig-install-tree.patch
#	${FILESDIR}/0008-COMP-Setting-CMAKE_MODULE_PATH-to-account-for-CTK-an.patch
#	${FILESDIR}/0009-COMP-Adding-conditional-to-SlicerBlockAdditionalLaun.patch
#	${FILESDIR}/0010-COMP-Add-installation-of-missing-files.patch
#	${FILESDIR}/0011-COMP-Enable-install-of-development-files-in-Slicer-l.patch
#	${FILESDIR}/0012-COMP-Adding-MRML_LIBRARIES-variable-to-install-confi.patch
#	${FILESDIR}/0013-COMP-Change-Slicer_ROOT-by-Slicer_HOME-in-UseSlicer..patch
#	${FILESDIR}/0014-COMP-Add-QTLOADABLEMODULES-dirs-in-intall-tree-confi.patch
#	${FILESDIR}/0015-COMP-Adding-conditional-for-installation-of-QT-desig.patch
#	${FILESDIR}/0016-COMP-Enable-installation-of-generated-.h-files-for-B.patch
#	${FILESDIR}/0017-COMP-Enable-installation-of-header-files-for-qMRMLWi.patch

	${FILESDIR}/0001-COMP-Remove-uneccessary-link-libraries-for-QTCore.patch
	${FILESDIR}/0002-COMP-Fix-link-libraries-in-QTGUI.patch
	${FILESDIR}/0003-COMP-Enable-Slicer_INSTALL_DEVELOPMENT-option.patch
	${FILESDIR}/0004-COMP-Fix-path-for-slicer-installation-headers.patch
	${FILESDIR}/0005-COMP-Adding-conditional-for-including-python-testing.patch
	${FILESDIR}/0006-COMP-Change-path-for-installing-qSlicerUtilsTest1.cx.patch
	${FILESDIR}/0007-COMP-Generate-and-Install-SlicerConfig-install-tree.patch
	${FILESDIR}/0008-COMP-Setting-CMAKE_MODULE_PATH-to-account-for-CTK-an.patch
	${FILESDIR}/0009-COMP-Adding-conditional-to-SlicerBlockAdditionalLaun.patch
	${FILESDIR}/0010-COMP-Add-installation-of-missing-files.patch
	${FILESDIR}/0011-COMP-Enable-install-of-development-files-in-Slicer-l.patch
	${FILESDIR}/0012-COMP-Adding-MRML_LIBRARIES-variable-to-install-confi.patch
	${FILESDIR}/0013-COMP-Change-Slicer_ROOT-by-Slicer_HOME-in-UseSlicer..patch
	${FILESDIR}/0014-COMP-Add-QTLOADABLEMODULES-dirs-in-intall-tree-confi.patch
	${FILESDIR}/0015-COMP-Adding-conditional-for-installation-of-QT-desig.patch
	${FILESDIR}/0016-COMP-Enable-installation-of-generated-.h-files-for-B.patch
	${FILESDIR}/0017-COMP-Enable-installation-of-header-files-for-qMRMLWi.patch
	${FILESDIR}/0018-COMP-Change-JsonCpp-by-jsoncpp.patch
	${FILESDIR}/0019-COMP-Adding-link-directories-for-ModuleParser.patch

)

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DSlicer_SUPERBUILD=OFF
		-DBUILD_TESTING=OFF
		-DSlicer_BUILD_EXTENSIONMANAGER_SUPPORT=OFF
		-DSlicer_BUILD_CLI_SUPPORT=ON
		-DSlicer_BUILD_CLI=OFF
		-DCMAKE_CXX_STANDARD=11
		-DSlicer_REQUIRED_QT_VERSION=5
		-DSlicer_BUILD_DICOM_SUPPORT=OFF
		-DSlicer_BUILD_ITKPython=OFF
		-DSlicer_BUILD_QTLOADABLEMODULES=OFF
		-DSlicer_BUILD_QT_DESIGNER_PLUGINS=ON
		-DSlicer_USE_CTKAPPLAUNCHER=OFF
		-DSlicer_USE_PYTHONQT=OFF
		-DSlicer_USE_QtTesting=OFF
		-DSlicer_USE_SimpleITK=OFF
		-DSlicer_VTK_RENDERING_BACKEND=OpenGL2
		-DSlicer_VTK_VERSION_MAJOR=8
		-DSlicer_INSTALL_DEVELOPMENT=ON
		-DCMAKE_INSTALL_RPATH=/usr/lib64/Slicer-4.11:/usr/lib64/ctk-0.1:/usr/lib64/Slicer-4.11/qt-loadable-modules:/usr/lib64/ITK-5.1.0
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
		-DSlicer_USE_SYSTEM_LibArchive=ON
		-DTeem_DIR=/usr/lib64
		-DjqPlot_DIR=/usr/share/jqPlot
		-DCTKAppLauncherLib_DIR=/usr/lib64/CTKAppLauncher-1.0.0

	)
	cmake-utils_src_configure
}
