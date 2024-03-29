# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake git-r3

DESCRIPTION="Software for end-users to access Plus library's features"
HOMEPAGE="https://www.plustoolkit.org/"
EGIT_REPO_URI="https://github.com/PlusToolkit/PlusApp"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE="fCal OpenIGTLink"

DEPEND="
	sci-medical/PlusLib[OpenIGTLink,widgets]
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/test.patch"
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DPLUSAPP_BUILD_fCal:BOOL=$(usex fCal ON OFF)
		-DPLUSAPP_INSTALL_CONFIG_DIR:FILEPATH=/etc/PlusApp
		# TODO: This should be fixed in VTK so we don't need to specify the VTK_DIR or ITK_DIR
		# -DVTK_DIR:STRING=/usr/lib64/cmake/vtk-9.1
		# -DITK_DIR:STRING=/usr/lib64/cmake/ITK-5.4
		# -DOpenIGTLinkIO_DIR:FILEPATH=/usr/lib64/cmake/igtlio
	)

	cmake_src_configure
}
