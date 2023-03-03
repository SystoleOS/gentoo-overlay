# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )

inherit cmake python-single-r1

# Short one-line description of this package.
DESCRIPTION="General-purpose features that may be integrated into VTK library in the future."

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/vtkAddon"

SRC_URI="https://github.com/Slicer/vtkAddon/archive/fb7edc86fc16ace43398f6743eff5a47f8ca0328.tar.gz -> vtkAddon.tar.gz"

LICENSE="BSD"

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
	${FILESDIR}/0001-ENH-Add-versioning-and-use-of-CMake-GNUInstallDirs.patch
	${FILESDIR}/0002-ENH-Add-CMake-directory-to-CMAKE_MODULE_PATH.patch
)

src_unpack(){
	default
	mv ${WORKDIR}/* ${WORKDIR}/${P}
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
