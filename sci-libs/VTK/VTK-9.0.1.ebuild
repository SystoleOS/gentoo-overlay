# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
WEBAPP_OPTIONAL=yes
WEBAPP_MANUAL_SLOT=yes

# Short package version
SPV="$(ver_cut 1-2)"
inherit python-single-r1 cmake

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="https://www.vtk.org/"
SRC_URI="
	https://www.vtk.org/files/release/${SPV}/VTK-${PV}.tar.gz
	doc? ( https://www.vtk.org/files/release/${SPV}/vtkDocHtml-${PV}.tar.gz )
	examples? (
		https://www.vtk.org/files/release/${SPV}/VTKData-${PV}.tar.gz
		https://www.vtk.org/files/release/${SPV}/VTKLargeData-${PV}.tar.gz
	)"

LICENSE="BSD LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="all-modules aqua boost doc examples ffmpeg gdal -gl2ps imaging java json mpi
	odbc offscreen postgres python qt5 R rendering tbb tcl -theora
	video_cards_nvidia views web +X xdmf2"

REQUIRED_USE="
	all-modules? ( python xdmf2 boost )
	java? ( qt5 )
	python? ( ${PYTHON_REQUIRED_USE} )
	tcl? ( rendering )
	examples? ( python )
	web? ( python )
	^^ ( X aqua offscreen )"

RDEPEND="
	app-arch/lz4
	dev-cpp/eigen
	dev-db/sqlite
	dev-libs/double-conversion:0=
	dev-libs/expat
	dev-libs/jsoncpp:=
	dev-libs/libxml2:2
	dev-libs/pugixml
	>=media-libs/freetype-2.5.4
	media-libs/glew:0=
	>=media-libs/libharu-2.3.0-r2
	media-libs/libpng:0=
	media-libs/libtheora
	media-libs/mesa
	media-libs/tiff:0
	sci-libs/exodusii
	sci-libs/hdf5:=
	sci-libs/netcdf:0=
	sci-libs/netcdf-cxx:3
	sci-libs/proj
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	boost? ( dev-libs/boost:=[mpi?] )
	examples? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
	)
	ffmpeg? ( media-video/ffmpeg )
	gdal? ( sci-libs/gdal )
	java? ( >=virtual/jdk-1.7:* )
	mpi? (
		virtual/mpi[cxx,romio]
		$(python_gen_cond_dep '
			python? ( dev-python/mpi4py[${PYTHON_USEDEP}] )
		')
	)
	odbc? ( dev-db/unixODBC )
	offscreen? ( media-libs/mesa[osmesa] )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/sip[${PYTHON_USEDEP}]
		')
	)
	qt5? (
		dev-qt/designer:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtsql:5
		dev-qt/qtx11extras:5
		$(python_gen_cond_dep '
			python? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
		')
	)
	R? ( dev-lang/R )
	tbb? ( dev-cpp/tbb )
	tcl? ( dev-lang/tcl:0= )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers[tools,static-libs] )
	web? (
		${WEBAPP_DEPEND}
		$(python_gen_cond_dep '
			dev-python/autobahn[${PYTHON_USEDEP}]
			dev-python/constantly[${PYTHON_USEDEP}]
			dev-python/hyperlink[${PYTHON_USEDEP}]
			dev-python/incremental[${PYTHON_USEDEP}]
			dev-python/txaio[${PYTHON_USEDEP}]
			dev-python/zope-interface[${PYTHON_USEDEP}]
		')
	)
	xdmf2? ( sci-libs/xdmf2 )
	gl2ps? ( x11-libs/gl2ps )
"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}"/VTK-${PV}

PATCHES=(
)

RESTRICT="test"

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use python && python-single-r1_pkg_setup
	use web && webapp_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	if use doc; then
		einfo "Removing .md5 files from documents."
		rm -f "${WORKDIR}"/html/*.md5 || die "Failed to remove superfluous hashes"
		sed -e "s|\${VTK_BINARY_DIR}/Utilities/Doxygen/doc|${WORKDIR}|" \
			-i Utilities/Doxygen/CMakeLists.txt || die
	fi
}

src_configure() {
	# general configuration
	local mycmakeargs=(
		-Wno-dev
		-DVTK_INSTALL_LIBRARY_DIR=$(get_libdir)
		-DVTK_INSTALL_PACKAGE_DIR="$(get_libdir)/cmake/${PN}-${SPV}"
		-DVTK_INSTALL_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DVTK_CUSTOM_LIBRARY_SUFFIX=""
		-DBUILD_SHARED_LIBS=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_expat=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_freetype=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_hdf5=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_jpeg=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_libproj=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_libxml2=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_netcdf=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_png=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_tiff=ON
		-DVTK_MODULE_USE_EXTERNAL_VTK_zlib=ON
		-DVTK_USE_LARGE_DATA=ON
		-DVTK_EXTRA_COMPILER_WARNINGS=ON
		-DVTK_GROUP_ENABLE_StandAlone=YES
		-DVTK_BUILD_DOCUMENTATION=$(usex doc)
		-DVTK_BUILD_EXAMPLES=$(usex examples)
		-DVTK_BUILD_ALL_MODULES=$(usex all-modules)
		-DVTK_GROUP_ENABLE_Imaging=$(usex imaging YES NO)
		-DVTK_GROUP_ENABLE_MPI=$(usex mpi YES NO)
		-DVTK_GROUP_ENABLE_Rendering=$(usex rendering YES NO)
		-DVTK_GROUP_ENABLE_Views=$(usex views YES NO)
		-DVTK_GROUP_ENABLE_Web=$(usex web YES NO)
		-DVTK_SMP_IMPLEMENTATION_TYPE="$(usex tbb TBB Sequential)"
		-DVTK_WRAP_JAVA=$(usex java)
		-DVTK_WRAP_PYTHON=$(usex python)
		-DVTK_MODULE_ENABLE_VTK_InfovisBoost=$(usex boost YES NO)
		-DVTK_MODULE_ENABLE_VTK_InfovisBoostGraphAlgorithms=$(usex boost YES NO)
		-DVTK_MODULE_ENABLE_VTK_IOODBC=$(usex odbc YES NO)
		-DVTK_DEFAULT_RENDER_WINDOW_OFFSCREEN=$(usex offscreen)
		-DVTK_OPENGL_HAS_OSMESA=$(usex offscreen)
		-DVTK_USE_NVCONTROL=$(usex video_cards_nvidia)
		-DVTK_USE_X=$(usex X)
		-DVTK_MODULE_USE_EXTERNAL_VTK_eigen=ON
	# IO
		-DVTK_USE_FFMPEG_ENCODER=$(usex ffmpeg)
		-DVTK_MODULE_ENABLE_VTK_IOGDAL=$(usex gdal YES NO)
		-DVTK_MODULE_ENABLE_VTK_IOGeoJSON=$(usex json YES NO)
		-DVTK_MODULE_ENABLE_VTK_IOXdmf2=$(usex xdmf2 YES NO)
		-DBUILD_TESTING=$(usex examples)
	# Apple stuff, does it really work?
		-DVTK_USE_COCOA=$(usex aqua)
		# Theora support
		-DVTK_MODULE_ENABLE_VTK_ogg=$(usex theora YES NO)
		-DVTK_MODULE_ENABLE_VTK_IOOggTheora=$(usex theora YES NO)
		-DVTK_MODULE_USE_EXTERNAL_VTK_oggtheora=ON
		# gl2ps support
		-DVTK_MODULE_ENABLE_VTK_gl2ps=$(usex gl2ps YES NO)
		-DVTK_MODULE_ENABLE_VTK_IOExportGL2PS=$(usex gl2ps YES NO)
		-DVTK_MODULE_USE_EXTERNAL_VTK_gl2ps=ON
		# Doxygen documentation
		-DDOXYGEN_GENERATE_HTMLHELP=$(usex doc ON OFF)
		# Use MPI
		-DVTK_USE_SYSTEM_MPI4PY=$(usex mpi ON OFF)
	)

	if use java; then
		local javacargs=$(java-pkg_javac-args)
		mycmakeargs+=( -DJAVAC_OPTIONS=${javacargs// /;} )
	fi

	if use python; then

		# Determine CMake variables depending on python major version
		if python_is_python3; then
			mycmakeargs+=(
				-DVTK_PYTHON_VERSION="3"
				-DPython3_EXECUTABLE="${PYTHON}"
			)

			case "${EPYTHON}" in

				# Python >=3.7 installs in /usr/lib
				python3.[789])
					mycmakeargs+=(
						-DVTK_PYTHON_SITE_PACKAGES_SUFFIX=lib/${EPYTHON}/site-packages
					)
					;;

				# Python < 3.7 installs in /usr/lib64
				python3.6)
					mycmakeargs+=(
						-DVTK_PYTHON_SITE_PACKAGES_SUFFIX=lib64/${EPYTHON}/site-packages
					)
					;;
			esac

		# If Python 2
		else
			mycmakeargs+=(
				-DVTK_PYTHON_VERSION="2"
				-DPython2_EXECUTABLE="${PYTHON}"
				-DVTK_PYTHON_SITE_PACKAGES_SUFFIX=lib64/${EPYTHON}/site-packages
			)
		fi
	fi

	if use qt5; then
		mycmakeargs+=(
			-DVTK_GROUP_ENABLE_Qt=YES
			-DVTK_MODULE_ENABLE_VTK_ViewsCore=YES
			-DVTK_MODULE_ENABLE_VTK_ViewsInfovis=YES
			-DVTK_MODULE_ENABLE_VTK_InfovisCore=YES
			-DVTK_MODULE_ENABLE_VTK_InteractionStyle=YES
			-DVTK_MODULE_ENABLE_VTK_ChartsCore=YES
			-DVTK_MODULE_ENABLE_VTK_InteractionWidgets=YES
			-DVTK_GROUP_ENABLE_Rendering=YES

		)
	fi

	if use R; then
		mycmakeargs+=(
			-DR_LIBRARY_BLAS=/usr/$(get_libdir)/R/lib/libR.so
			-DR_LIBRARY_LAPACK=/usr/$(get_libdir)/R/lib/libR.so
		)
	fi

	append-cppflags -D__STDC_CONSTANT_MACROS -D_UNICODE

	use java && export JAVA_HOME="${EPREFIX}/etc/java-config-2/current-system-vm"

	if use mpi; then
		export CC=mpicc
		export CXX=mpicxx
		export FC=mpif90
		export F90=mpif90
		export F77=mpif77
	fi

	cmake_src_configure
}

src_install() {
	use web && webapp_src_preinst

	cmake_src_install

	use java && java-pkg_regjar "${ED}"/usr/$(get_libdir)/${PN}.jar

	# Stop web page images from being compressed
	use doc && docompress -x /usr/share/doc/${PF}/doxygen

	use python && python_optimize "${D}"$(python_get_sitedir)

	# install examples
	if use examples; then
		einfo "Installing examples"
		mv -v {E,e}xamples || die
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	# environment
	cat >> "${T}"/40${PN} <<- EOF || die
		VTK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data
		VTK_DIR=${EPREFIX}/usr/$(get_libdir)/${PN}-${SPV}
		VTKHOME=${EPREFIX}/usr
		EOF
	doenvd "${T}"/40${PN}

	use web && webapp_src_install
}

# webapp.eclass exports these but we want it optional #534036
pkg_postinst() {
	use web && webapp_pkg_postinst
}

pkg_prerm() {
	use web && webapp_pkg_prerm
}
