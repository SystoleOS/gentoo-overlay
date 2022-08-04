# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

PYTHON_COMPAT=( python3_9 )

inherit cmake python-single-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="Volumes module for 3D-Slicer"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="master"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"

SLOT="0"

DEPEND="
	sci-medical/Slicer
	Slicer-Loadable/SubjectHierarchy
	Slicer-Loadable/Units
	Slicer-Loadable/Colors
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

PATCHES=(
	${FILESDIR}/0001-Make-Volumes-a-separate-module.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DCMAKE_CXX_STANDARD=11
		-DCMAKE_INSTALL_RPATH=/usr/lib64/Slicer-4.11:/usr/lib64/ctk-0.1:/usr/lib64/Slicer-4.11/qt-loadable-modules:/usr/lib64/ITK-5.1.0
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
		-DqSlicer${PN}ModuleWidgets_DEVELOPMENT_INSTALL=ON
		-DvtkSlicer${PN}ModuleLogic_DEVELOPMENT_INSTALL=ON
		-DSlicer_VTK_WRAP_HIERARCHY_DIR=${WORKDIR}
		-DSlicer_QTLOADABLEMODULES_LIB_DIR=lib64/Slicer-4.11/qt-loadable-modules
		-DSlicer_QTSCRIPTEDMODULES_LIB_DIR=/lib64/Slicer-4.11/qt-scripted-modules
		-DSlicer_INSTALL_QTSCRIPTEDMODULES_LIB_DIR=lib64/Slicer-4.11/qt-scripted-modules
		-DPYTHON_INCLUDE_DIR="$(python_get_sitedir)"
	)

	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/Loadable/${PN}"
	cmake_src_configure
}
