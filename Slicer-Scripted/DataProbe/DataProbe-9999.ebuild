# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="DataProbe module for 3D-Slicer"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="main"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"

DEPEND="
	sci-medical/Slicer[python]
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

BDEPEND="
	sci-medical/ctk[python]
"

PATCHES=(
	"${FILESDIR}/0001-ENH-Make-DataProbe-a-separate-module.patch"
)

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="17"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-DPYTHON_INCLUDE_DIR:STRING="$(python_get_sitedir)"
		-DSlicer_VTK_WRAP_HIERARCHY_DIR="${WORKDIR}"
	)

	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/Scripted/${PN}"
	cmake_src_configure
}
