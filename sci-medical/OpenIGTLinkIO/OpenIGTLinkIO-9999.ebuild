EAPI=7

inherit cmake git-r3

DESCRIPTION="Library for interfacing to openigtlink/OpenIGTLink, dependent on VTK and Qt. Based on openigtlink/OpenIGTLinkIF"
HOMEPAGE="https://github.com/IGSIO/OpenIGTLinkIO"

EGIT_REPO_URI="https://github.com/IGSIO/OpenIGTLinkIO"
EGIT_BRANCH="master"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sci-libs/vtk-9.1.0
	sci-medical/OpenIGTLink
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
		# TODO: This should be fixed in VTK so we don't need to specify the VTK_DIR or ITK_DIR
		-DVTK_DIR:STRING=/usr/lib64/cmake/vtk-9.1
		-DOpenIGTLink_DIR:FILEPATH=/usr/lib64/cmake/igtl-3.1
		-DOpenIGTLinkIO_LIBRARY_INSTALL:STRING=$(get_libdir)
	)

	cmake_src_configure
}
