# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="Texts module for 3D-Slicer"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="main"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="BSD"
SLOT="0"
IUSE="python"

DEPEND="
	sci-medical/Slicer[python?]
	Slicer-Loadable/SubjectHierarchy[python?]
	Slicer-Loadable/Markups[python?]
"

RDEPEND="
	${DEPEND}
	python? (
		${PYTHON_DEPS}
		)
"
REQUIRED_USE="
	python? (
		${PYTHON_REQUIRED_USE}
		)
"

PATCHES=(
	"${FILESDIR}/0001-ENH-Make-Texts-a-separate-module.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="17"
		-DqSlicer${PN}ModuleWidgets_DEVELOPMENT_INSTALL:BOOL=ON
		-DvtkSlicer${PN}ModuleLogic_DEVELOPMENT_INSTALL:BOOL=ON
		-DSlicer_USE_PYTHONQT:BOOL=$(usex python ON OFF)
	)

	if use python; then
	   mycmakeargs+=(
		   -DSlicer_VTK_WRAP_HIERARCHY_DIR:STRING="${WORKDIR}"
		   -DPython3_INCLUDE_DIR:FILEPATH="$(python_get_includedir)"
		   -DPython3_LIBRARY:FILEPATH="$(python_get_library_path)"
		   -DPython3_EXECUTABLE:FILEPATH="${PYTHON}"
	   )
	fi

	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/Loadable/${PN}"
	cmake_src_configure
}
