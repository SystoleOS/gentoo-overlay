# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

PYTHON_COMPAT=( python3_9 )

inherit cmake git-r3 python-r1

# Short one-line description of this package.
DESCRIPTION="General-purpose features that may be integrated into VTK library in the future."

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/vtkAddon"

EGIT_REPO_URI="https://github.com/Slicer/vtkAddon"
EGIT_BRANCH="master"

LICENSE="BSD"

SLOT="0"

IUSE="python"

DEPEND="
	sci-libs/vtk
	python? ( ${PYTHON_DEPS}
			  sci-libs/VTK[python] )
	!python? ( sci-libs/VTK )
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=()

src_configure(){

	vtkAddon_configure(){

		local mycmakeargs=()

		mycmakeargs+=(
			-DBUILD_SHARED_LIBS:BOOL=ON
			-DBUILD_TESTING:BOOL=OFF
			-DvtkAddon_WRAP_PYTHON:BOOL="$(usex python ON OFF)"
			-DvtkAddon_INSTALL_NO_DEVELOPMENT:BOOL=OFF
			-DvtkAddon_INSTALL_LIB_DIR:STRING="$(get_libdir)"
			-DvtkAddon_INSTALL_CMAKE_DIR:STRING="$(get_libdir)/cmake/${PN}"
		)

		if use python; then
			mycmakeargs+=(
				-DvtkAddon_INSTALL_PYTHON_MODULE_LIB_DIR:STRING="$(python_get_sitedir)"
				-DvtkAddon_INSTALL_PYTHON_LIB_DIR:STRING="$(get_libdir)"
			)
		fi

		cmake_src_configure
	}

	python_foreach_impl vtkAddon_configure
}

src_compile()
{
	python_foreach_impl run_in_build_dir cmake_src_compile
}

src_install(){

	vtkAddon_install(){

		cmake_src_install

		use python && python_optimize "${D}"$(python_get_sitedir)
	}

	python_foreach_impl vtkAddon_install
}
