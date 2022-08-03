# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

inherit cmake git-r3

# Short one-line description of this package.
DESCRIPTION="Model Maker module for 3D Slicer"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="master"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

DEPEND="
	sci-medical/Slicer
"

RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/0001-COMP-Make-ModelMaker-a-separate-module.patch
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
