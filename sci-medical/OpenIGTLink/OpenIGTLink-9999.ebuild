EAPI=7

inherit cmake git-r3

DESCRIPTION="Free, open-source network communication library for image-guided therapy"
HOMEPAGE="http://openigtlink.org"

EGIT_REPO_URI="https://github.com/openigtlink/OpenIGTLink"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
