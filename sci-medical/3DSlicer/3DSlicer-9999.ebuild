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
	sci-medical/CTK
"

RDEPEND="${DEPEND}"

PATCHES=( )

src_unpack() {
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi

	mv ${WORKDIR}/Slicer-master ${WORKDIR}/${PN}-${PV}
}

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DSlicer_SUPERBUILD=OFF
		-DBUILD_TESTING=OFF
		-DSlicer_BUILD_EXTENSIONMANAGER_SUPPORT=OFF
		-DSlicer_BUILD_CLI_SUPPORT=OFF
		-DSlicer_BUILD_CLI=OFF
		-DCMAKE_CXX_STANDARD=11
		-DSlicer_REQUIRED_QT_VERSION=5
		-DSlicer_BUILD_DICOM_SUPPORT=OFF
		-DSlicer_BUILD_ITKPython=OFF
		-DSlicer_BUILD_QTLOADABLEMODULES=OFF
		-DSlicer_BUILD_QT_DESIGNER_PLUGINS=OFF
		-DSlicer_USE_CTKAPPLAUNCHER=OFF
		-DSlicer_USE_PYTHONQT=OFF
		-DSlicer_USE_QtTesting=OFF
		-DSlicer_USE_SimpleITK=OFF
		-DSlicer_VTK_RENDERING_BACKEND=OpenGL2
		-DSlicer_VTK_VERSION_MAJOR=8
		-DSlicer_INSTALL_DEVELOPMENT=ON
		-DCMAKE_INSTALL_RPATH=/usr/lib64/Slicer-4.10:/usr/lib64/ctk-0.1:/usr/lib64/Slicer-4.10/qt-loadable-modules
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
		-DSlicer_USE_SYSTEM_LibArchive=ON
		-DTeem_DIR=/usr/lib64
		-DjqPlot_DIR=/usr/share/jqPlot
	)
	cmake-utils_src_configure
}
