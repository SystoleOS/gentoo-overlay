EAPI=7

inherit cmake git-r3

DESCRIPTION="Software applications that makes Plus library's data acquisition, calibration, and real-time straming features available to end-users."
HOMEPAGE="https://www.plustoolkit.org/"
EGIT_REPO_URI="https://github.com/PlusToolkit/PlusApp"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fCal OpenIGTLink"

DEPEND="
	sci-medical/PlusLib[OpenIGTLink,widgets]
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	${FILESDIR}/test.patch
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


src_install(){

	cmake_src_install
}
