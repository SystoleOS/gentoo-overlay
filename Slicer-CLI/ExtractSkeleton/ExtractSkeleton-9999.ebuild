# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake git-r3

# Short one-line description of this package.
DESCRIPTION="Extract Skeleton module for 3D Slicer"

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
	sci-medical/Slicer
	Slicer-Loadable/Markups
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-ENH-Make-the-ExtractSkeleton-CLI-module-a-separate-m.patch"
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="11"
	)
	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/CLI/${PN}"
	cmake_src_configure
}
