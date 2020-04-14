# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7
PYTHON_COMPAT=( python3_6 )

inherit cmake-utils git-r3 python-single-r1

# Short one-line description of this package.
DESCRIPTION="General-purpose features that may be integrated into VTK library in the future."

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/vtkAddon"

EGIT_REPO_URI="https://github.com/Slicer/vtkAddon"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""
REQURIED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"

RDEPEND="${DEPEND}"

PATCHES=()

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DBUILD_TESTING:BOOL=OFF
		-DvtkAddon_WRAP_PYTHON:BOOL=ON
		-DvtkAddon_INSTALL_NO_DEVELOPMENT:BOOL=OFF
		-DvtkAddon_INSTALL_LIB_DIR:STRING="$(get_libdir)"
		-DvtkAddon_INSTALL_CMAKE_DIR:STRING="$(get_libdir)/cmake/${PN}"
		-DvtkAddon_INSTALL_PYTHON_MODULE_LIB_DIR:STRING="$(python_get_sitedir)"
		-DvtkAddon_INSTALL_PYTHON_LIB_DIR:STRING="$(get_libdir)"
	)

	cmake-utils_src_configure
}

src_install(){

	cmake-utils_src_install
	python_optimize
}
