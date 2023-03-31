# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake git-r3

# Short one-line description of this package.
DESCRIPTION="A toolbox for rigid and nonrigid registration of images"

EGIT_REPO_URI="https://github.com/SuperElastix/elastix"
EGIT_BRANCH="develop"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://elastix.isi.uu.nl/"

LICENSE="Apache-2.0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"

DEPEND="
	>=sci-libs/itk-5.0
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-ENH-Removing-limitation-for-only-STATIC-libraries.patch"
)

src_prepare() {

	cmake_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="11"
		-DELASTIX_USE_OPENCL:BOOL=OFF
		-DELASTIX_USE_OPENMP:BOOL=ON
		-DCMAKE_INSTALL_PREFIX:STRING="/usr"
		-DELASTIX_RUNTIME_DIR:STRING="bin"
		-DELASTIX_ARCHIVE_DIR:STRING="$(get_libdir)"
		-DELASTIX_LIBRARY_DIR:STRING="$(get_libdir)"
		-DELASTIX_INCLUDE_DIR:STRING="include/${PN}"
	)

	cmake_src_configure
}
