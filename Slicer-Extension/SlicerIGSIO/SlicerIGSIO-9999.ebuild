# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1 git-r3

DESCRIPTION="Utility extension for 3D Slicer, containing tools and algorithms for building image guided surgery applications"
HOMEPAGE="https://github.com/SystoleOS/SlicerIGSIO"
EGIT_REPO_URI="https://github.com/SystoleOS/SlicerIGSIO"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

DEPEND="
	sci-medical/Slicer[python?]
	Slicer-Loadable/Sequences[python?]
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
	${FILESDIR}/0001-ENH-Port-SlicerIGSIO-to-Systole-Slicer.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DSlicerIGSIO_SUPERBUILD:BOOL=OFF
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

	cmake_src_configure
}
