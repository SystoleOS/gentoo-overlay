# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake git-r3

DESCRIPTION="Free, open-source network communication library for image-guided therapy"
HOMEPAGE="http://openigtlink.org"

EGIT_REPO_URI="https://github.com/openigtlink/OpenIGTLink"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_BUILD_TYPE:STRING=Release
		-DOpenIGTLink_INSTALL_LIB_DIR:STRING=$(get_libdir)
	)

	cmake_src_configure
}
