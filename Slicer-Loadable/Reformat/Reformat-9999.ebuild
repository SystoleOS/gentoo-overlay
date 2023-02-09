# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

PYTHON_COMPAT=( python3_9 )

inherit cmake python-single-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="Reformat module for 3D-Slicer"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="main"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"

SLOT="0"

DEPEND="
	sci-medical/Slicer
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	${FILESDIR}/0001-ENH-Make-Reformat-a-separate-module.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="17"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-D${PN}_DEVELOPMENT_INSTALL:BOOL=ON
		-DqSlicer${PN}ModuleWidgets_DEVELOPMENT_INSTALL:BOOL=ON
		-DvtkSlicer${PN}ModuleLogic_DEVELOPMENT_INSTALL:BOOL=ON
		-DSlicer_VTK_WRAP_HIERARCHY_DIR:STRING="${WORKDIR}"
		-DPYTHON_INCLUDE_DIR:STRING="$(python_get_sitedir)"
	)

	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/Loadable/${PN}"
	cmake_src_configure
}
