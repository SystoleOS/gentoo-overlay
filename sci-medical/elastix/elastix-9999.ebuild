# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils multilib git-r3

# Short one-line description of this package.
DESCRIPTION="3D Slicer is an open source software platform for medical image informatics,
image processing, and three-dimensional visualization. This package is a
live-build which will pull the master branch of the official 3D Slicer repository."

EGIT_REPO_URI="https://github.com/SuperElastix/elastix"
EGIT_BRANCH="develop"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://elastix.isi.uu.nl/"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

DEPEND="
	>=sci-libs/ITK-5.0
"

RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/0001-Adding-CMAKE_INSTALL_RPATH-to-rpath-properties-of-ex.patch
)

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DCMAKE_CXX_STANDARD=11
		-DELASTIX_USE_OPENCL=ON
		-DELASTIX_USE_OPENMP=ON
		-DCMAKE_INSTALL_PREFIX=/usr
		-DELASTIX_RUNTIME_DIR=bin
		-DELASTIX_ARCHIVE_DIR=lib64/elastix-4.9.0
		-DELASTIX_LIBRARY_DIR=lib64/elastix-4.9.0
		-DELASTIX_LIBRARY_DIR=lib64/elastix-4.9.0
		-DCMAKE_INSTALL_RPATH=/usr/lib64/elastix-4.9.0:/usr/lib64/ITK-5.1.0
	)

	cmake-utils_src_configure
}
