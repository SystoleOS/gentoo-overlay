# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-single-r1

# Short one-line description of this package.
DESCRIPTION="General-purpose features that may be integrated into VTK library in the future."

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/vtkAddon"

SRC_URI="https://github.com/Slicer/vtkAddon/archive/4413fde380b744ab221f7beb4410e11a5158b496.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"

IUSE="python"

DEPEND="
	sci-libs/vtk
	python? ( ${PYTHON_DEPS}
			  sci-libs/vtk[python] )
	!python? ( sci-libs/vtk )
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/0001-ENH-Add-versioning-and-use-of-CMake-GNUInstallDirs.patch"
	"${FILESDIR}/0002-ENH-Add-CMake-directory-to-CMAKE_MODULE_PATH.patch"
	"${FILESDIR}/0003-ENH-Modernize-Python-finding.patch"
)

src_unpack(){
	default
	mv "${WORKDIR}"/* "${WORKDIR}"/"${P}"
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DBUILD_TESTING:BOOL=OFF
		-DvtkAddon_WRAP_PYTHON:BOOL="$(usex python ON OFF)"
		-DvtkAddon_INSTALL_NO_DEVELOPMENT:BOOL=OFF
		-DvtkAddon_INSTALL_LIB_DIR:STRING="$(get_libdir)"
	)

	if use python; then
		mycmakeargs+=(
			-DvtkAddon_INSTALL_PYTHON_MODULE_LIB_DIR:STRING="$(python_get_sitedir)"
			-DvtkAddon_INSTALL_PYTHON_LIB_DIR:STRING="$(get_libdir)"
		)
	fi

	cmake_src_configure
}

src_install(){

	cmake_src_install
	use python && python_optimize "${D}"$(python_get_sitedir)
}
