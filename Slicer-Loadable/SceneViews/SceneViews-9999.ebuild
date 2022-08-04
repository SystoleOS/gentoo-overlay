# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

PYTHON_COMPAT=( python3_9 )

inherit cmake python-single-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="SceneViews module for 3D-Slicer"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="master"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

DEPEND="
	sci-medical/Slicer
	Slicer-Loadable/SubjectHierarchy
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	${FILESDIR}/0001-ENH-Make-SceneViews-a-separate-module.patch
	${FILESDIR}/0002-COMP-Fix-compilation-error-on-python-wrapping.patch
	${FILESDIR}/0003-COMP-Remove-redundant-declaration-of-special-functio.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_CXX_STANDARD="11"
		-DCMAKE_INSTALL_RPATH="/usr/$(get_libdir)/Slicer-4.11/qt-loadable-modules"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-D${PN}_DEVELOPMENT_INSTALL:BOOL=ON
		-DvtkSlicer${PN}ModuleLogic_DEVELOPMENT_INSTALL:BOOL=ON
		-DSlicer_VTK_WRAP_HIERARCHY_DIR=${WORKDIR}
		-DSlicer_QTLOADABLEMODULES_LIB_DIR="$(get_libdir)/Slicer-4.11/qt-loadable-modules"
		-DSlicer_QTSCRIPTEDMODULES_LIB_DIR="$(get_libdir)/Slicer-4.11/qt-scripted-modules"
		-DSlicer_INSTALL_QTSCRIPTEDMODULES_LIB_DIR="$(get_libdir)/Slicer-4.11/qt-scripted-modules"
		-DPYTHON_INCLUDE_DIR="$(python_get_sitedir)"
	)

	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/Loadable/${PN}"
	cmake_src_configure
}
