# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1 git-r3

DESCRIPTION="3D Slicer Extension with image-guided surgery tools and algorithms."
HOMEPAGE="https://github.com/SlicerIGT/SlicerIGT"
EGIT_REPO_URI="https://github.com/SlicerIGT/SlicerIGT.git"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

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
	"${FILESDIR}/0001-ENH-Port-SlicerIGT-to-Systole.patch"
	"${FILESDIR}/0002-ENH-Add-missing-includes-for-standard-Qt-components.patch"
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
