EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1 git-r3

DESCRIPTION="Utility extension for 3D Slicer, containing tools and algorithms for building image guided surgery applications"
HOMEPAGE="https://github.com/OpenIGTLink/SlicerOpenIGTLink"
EGIT_REPO_URI="https://github.com/OpenIGTLink/SlicerOpenIGTLink"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sci-medical/Slicer[python]
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"
REQUIRED_USE="
		${PYTHON_REQUIRED_USE}
"

PATCHES=(
	${FILESDIR}/0001-ENH-Port-SlicerOpenIGTLink-to-Systole-Slicer.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DSlicerOpenIGTLink_SUPERBUILD:BOOL=OFF
		-DSlicer_USE_PYTHONQT:BOOL=ON
		-DOpenIGTLinkIO_DIR:FILEPATH=/usr/lib64/cmake/igtlio
		-DPython3_INCLUDE_DIR:FILEPATH="$(python_get_includedir)"
		-DPython3_LIBRARY:FILEPATH="$(python_get_library_path)"
		-DPython3_EXECUTABLE:FILEPATH="${PYTHON}"
		)

	cmake_src_configure
}