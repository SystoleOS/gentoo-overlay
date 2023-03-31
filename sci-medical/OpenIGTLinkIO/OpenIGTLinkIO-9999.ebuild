# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake git-r3

DESCRIPTION="Library for interfacing with OpenIGTLink using VTK and Qt"
HOMEPAGE="https://github.com/IGSIO/OpenIGTLinkIO"

EGIT_REPO_URI="https://github.com/IGSIO/OpenIGTLinkIO"
EGIT_BRANCH="master"

LICENSE="Apache-2.0"
SLOT="0"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

DEPEND="
	>=sci-libs/vtk-9.2.0
	sci-medical/OpenIGTLink
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/0001-ENH-Enable-installation-of-development-files.patch"
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		# TODO: This should be fixed in VTK so we don't need to specify the VTK_DIR or ITK_DIR
		-DVTK_DIR:STRING=/usr/lib64/cmake/vtk-9.2
		-DOpenIGTLink_DIR:FILEPATH=/usr/lib64/cmake/igtl-3.1
		-DOpenIGTLinkIO_LIBRARY_INSTALL:STRING=$(get_libdir)
		-DOpenIGTLinkIO_NO_INSTALL_DEVELOPMENT:BOOL=OFF
	)

	cmake_src_configure
}
