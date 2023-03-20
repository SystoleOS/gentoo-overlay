EAPI=7

inherit cmake git-r3

DESCRIPTION="A collection of tools and algorithms for image guided systems"
HOMEPAGE="https://github.com/IGSIO/IGSIO"
EGIT_REPO_URI="https://github.com/IGSIO/IGSIO"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sci-libs/vtk-9.1.0
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	${FILESDIR}/0001-ENH-Remove-include-vtkAddonTargets.cmake.patch
	${FILESDIR}/0002-ENH-Enable-install-tree.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_BUILD_TYPE:STRING=Release
		# TODO: This should be fixed in VTK so we don't need to specify the VTK_DIR or ITK_DIR
		-DVTK_DIR:STRING=/usr/lib64/cmake/vtk-9.1
		-DITK_DIR:STRING=/usr/lib64/cmake/ITK-5.4
		-DIGSIO_SUPERBUILD:BOOL=OFF
		-DIGSIO_INSTALL_LIB_DIR:FILEPATH=$(get_libdir)
		-DIGSIO_NO_DEVELOPMENT_INSTALL:BOOL=OFF
	)

	cmake_src_configure
}
