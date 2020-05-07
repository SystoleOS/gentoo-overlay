# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit cmake python-single-r1 git-r3

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
	sci-medical/Slicer
"

RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/0001-COMP-Make-terminologies-a-separate-module.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="11"
		-DCMAKE_INSTALL_RPATH:STRING="/usr/$(get_libdir)/Slicer-4.11/qt-loadable-modules"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-D${PN}_DEVELOPMENT_INSTALL:BOOL=ON
		-DqSlicer${PN}ModuleWidgets_DEVELOPMENT_INSTALL:BOOL=ON
		-DvtkSlicer${PN}ModuleLogic_DEVELOPMENT_INSTALL:BOOL=ON
		-DSlicer_VTK_WRAP_HIERARCHY_DIR:STRING="${WORKDIR}"
		-DSlicer_INSTALL_LIB_DIR:STRING="$(get_libdir)/Slicer-4.11"
		-DSlicer_QTLOADABLEMODULES_LIB_DIR:STRING="$(get_libdir)/Slicer-4.11/qt-loadable-modules"
		-DPYTHON_INCLUDE_DIR:STRING="$(python_get_include_dir)"
	)

	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/Loadable/${PN}"
	cmake_src_configure
}
