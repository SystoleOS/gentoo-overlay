# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

PYTHON_COMPAT=( python3_9 )

inherit cmake python-single-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="SampleData module for 3D-Slicer"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="master"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"

SLOT="0"

DEPEND="
	sci-medical/Slicer[python]
	Slicer-Loadable/Volumes
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	${FILESDIR}/0001-ENH-Make-the-SampleData-scripted-module-a-separate-m.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="11"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-DSlicer_QTLOADABLEMODULES_LIB_DIR:STRING="lib64/Slicer-4.11/qt-loadable-modules"
		-DSlicer_QTSCRIPTEDMODULES_LIB_DIR:STRING="lib64/Slicer-4.11/qt-scripted-modules"
		-DSlicer_INSTALL_QTSCRIPTEDMODULES_LIB_DIR:STRING="lib64/Slicer-4.11/qt-scripted-modules"
		-DPYTHON_INCLUDE_DIR:STRING="$(python_get_sitedir)"
	)

	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/Scripted/${PN}"
	cmake_src_configure
}
