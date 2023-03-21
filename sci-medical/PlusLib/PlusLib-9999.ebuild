EAPI=7

inherit cmake git-r3

DESCRIPTION="Software library for data acquisition, pre-processing, and calibration for navigated image-guided interventions"
HOMEPAGE="https://www.plustoolkit.org/"
EGIT_REPO_URI="https://github.com/PlusToolkit/PlusLib"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sci-libs/vtk-9.1.0[qt5,rendering,gl2ps]
	sci-libs/vtkAddon
	sci-medical/IGSIO[volume-reconstruction]
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	${FILESDIR}/0001-ENH-Fix-compile-using-install-tree-of-dependencies.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		# TODO: This should be fixed in VTK so we don't need to specify the VTK_DIR or ITK_DIR
		-DVTK_DIR:STRING=/usr/lib64/cmake/vtk-9.1
		-DITK_DIR:STRING=/usr/lib64/cmake/ITK-5.4
		-DOpenIGTLinkIO_DIR:FILEPATH=/usr/lib64/cmake/igtlio
	)

	cmake_src_configure
}
