EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1 git-r3

DESCRIPTION="Utility extension for 3D Slicer, containing tools and algorithms for building image guided surgery applications"
HOMEPAGE="https://github.com/SlicerIGT/SlicerIGT"
EGIT_REPO_URI="https://github.com/SlicerIGT/SlicerIGT"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sci-medical/Slicer[python]
	Slicer-Extension/SlicerIGSIO[python]
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

PATCHES=(
	${FILESDIR}/0001-ENH-Port-SlicerIGT-to-Systole.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DSlicer_USE_PYTHONQT:BOOL=ON
		-DSlicer_VTK_WRAP_HIERARCHY_DIR:STRING="${WORKDIR}"
		-DPython3_INCLUDE_DIR:FILEPATH="$(python_get_includedir)"
		-DPython3_LIBRARY:FILEPATH="$(python_get_library_path)"
		-DPython3_EXECUTABLE:FILEPATH="${PYTHON}"
		)

	cmake_src_configure
}
