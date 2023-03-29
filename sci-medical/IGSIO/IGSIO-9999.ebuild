# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake git-r3

DESCRIPTION="A collection of tools and algorithms for image guided systems"
HOMEPAGE="https://github.com/IGSIO/IGSIO"
EGIT_REPO_URI="https://github.com/IGSIO/IGSIO"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="volume-reconstruction"

DEPEND="
	sci-libs/vtk:0=
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
		# TODO: This should be fixed in VTK so we don't need to specify the VTK_DIR or ITK_DIR
		-DVTK_DIR:STRING=/usr/lib64/cmake/vtk-9.2
		-DITK_DIR:STRING=/usr/lib64/cmake/ITK-5.4
		-DIGSIO_SUPERBUILD:BOOL=OFF
		-DIGSIO_INSTALL_LIB_DIR:FILEPATH=$(get_libdir)
		-DIGSIO_NO_DEVELOPMENT_INSTALL:BOOL=OFF
		-DIGSIO_BUILD_VOLUMERECONSTRUCTION:BOOL=$(usex volume-reconstruction ON OFF)
	)

	cmake_src_configure
}
