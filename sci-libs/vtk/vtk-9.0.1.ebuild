# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
WEBAPP_OPTIONAL=yes
WEBAPP_MANUAL_SLOT=yes

# Short package version
SPV="$(ver_cut 1-2)"
inherit python-r1 cmake java-pkg-opt-2 virtualx

declare -a ADITIONAL_TEST_FILES=(
		https://vtk.org/files/ExternalData/MD5/eaab2cdba68e8630f9a1f8a8e81cb097
		https://vtk.org/files/ExternalData/MD5/8e09d028a9fd114b4ceb8f924d8b466c
		https://vtk.org/files/ExternalData/MD5/325acbb1a74ae27148d76399c2e7c7c5
		https://vtk.org/files/ExternalData/MD5/7e7e6c5e28fa93b16fe0414881bdbbcd
)

ADITIONAL_TEST_FILES_SRC=""
for i in "${ADITIONAL_TEST_FILES[@]}"; do
	ADITIONAL_TEST_FILES_SRC+="${i} "
done

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="https://www.vtk.org/"
SRC_URI="
	https://www.vtk.org/files/release/${SPV}/VTK-${PV}.tar.gz -> ${PN}-${PV}.tar.gz
	doc? ( https://www.vtk.org/files/release/${SPV}/vtkDocHtml-${PV}.tar.gz )
	test? (
		https://www.vtk.org/files/release/${SPV}/VTKData-${PV}.tar.gz -> ${PN}Data-${PV}.tar.gz
		https://www.vtk.org/files/release/${SPV}/VTKLargeData-${PV}.tar.gz -> ${PN}LargeData-${PV}.tar.gz
		${ADITIONAL_TEST_FILES_SRC}
	)"

LICENSE="BSD LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="all_modules aqua boost doc examples -exodus ffmpeg gdal -gl2ps imaging java json loguru mpi odbc offscreen postgres python qt5 R rendering tbb test tcl theora video_cards_nvidia views web +X xdmf2"

REQUIRED_USE="
	all_modules? ( python xdmf2 boost )
	java? ( qt5 )
	python? ( ${PYTHON_REQUIRED_USE} )
	tcl? ( rendering )
	examples? ( python )
	loguru? ( python )
	web? ( python )
	^^ ( X aqua offscreen )
"

RDEPEND="
	app-arch/lz4
	app-arch/lzma
	dev-cpp/eigen
	dev-db/sqlite
	dev-libs/double-conversion:0=
	dev-libs/expat
	>=dev-libs/jsoncpp-1.9.3
	dev-libs/libxml2:2
	dev-libs/pugixml
	>=media-libs/freetype-2.5.4
	media-libs/glew:0=
	>=media-libs/libharu-2.3.0-r2
	media-libs/libpng:0=
	media-libs/libtheora
	media-libs/mesa
	media-libs/tiff:0
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
	exodus? ( sci-libs/exodusii )
	ffmpeg? ( media-video/ffmpeg )
	gdal? ( sci-libs/gdal )
	java? ( >=virtual/jdk-1.7:* )
	loguru? ( dev-python/loguru )
	mpi? (
		app-admin/chrpath
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

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use python && python_setup
	use web && webapp_pkg_setup
}

src_unpack(){

	unpack ${PN}-${PV}.tar.gz
	use test && unpack ${PN}Data-${PV}.tar.gz
	use test && unpack ${PN}LargeData-${PV}.tar.gz
}

src_prepare() {

	cmake_src_prepare

	if use test; then
		mkdir -p ${S}/.ExternalData/MD5/
		for i in ${ADITIONAL_TEST_FILES[@]}; do
			einfo "cp ${i##*/} ${S}/.ExternalData/MD5/${i##*/}"
			cp ${DISTDIR}/${i##*/} ${S}/.ExternalData/MD5/${i##*/}
		done
	fi

	if use doc; then
		einfo "Removing .md5 files from documents."
		rm -f "${WORKDIR}"/html/*.md5 || die "Failed to remove superfluous hashes"
		sed -e "s|\${VTK_BINARY_DIR}/Utilities/Doxygen/doc|${WORKDIR}|" \
			-i Utilities/Doxygen/CMakeLists.txt || die
	fi
}

src_configure() {

	# Utility function to enable external modules (args 2..n) based on
	# the activation of an use flag (arg 1)
	vtk_enable_external(){

		# If only one argument is provided. Then the argument is the module
		# to use externally
		if [ $# -eq 1 ]; then
			echo -DVTK_MODULE_USE_EXTERNAL_VTK_${1}=ON

		# If there are more than one argument. Then, the first argument is the module
		# use flag to check and from the second argument, the modules enabled externally
		elif [ $# -gt 1 ]; then
			for ((i=2; i<=$#; i++)); do
				use ${1} && echo -DVTK_MODULE_USE_EXTERNAL_VTK_${!i}=ON
			done
		fi
	}

	vtk_configure() {
		local mycmakeargs=(
			-Wno-dev
			-DVTK_INSTALL_LIBRARY_DIR=$(get_libdir)
			-DVTK_INSTALL_PACKAGE_DIR="$(get_libdir)/cmake/${PN}-${SPV}"
			-DVTK_INSTALL_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
			-DVTK_CUSTOM_LIBRARY_SUFFIX=""
			-DBUILD_SHARED_LIBS=ON
			-DVTK_USE_LARGE_DATA=ON
			-DVTK_EXTRA_COMPILER_WARNINGS=ON
			-DVTK_GROUP_ENABLE_StandAlone=YES
			-DVTK_BUILD_DOCUMENTATION=$(usex doc)
			-DVTK_BUILD_EXAMPLES=$(usex examples)
			-DVTK_BUILD_ALL_MODULES=$(usex all_modules ON OFF)
			-DVTK_GROUP_ENABLE_Imaging=$(usex imaging YES NO)
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
			# IO
			-DVTK_USE_FFMPEG_ENCODER=$(usex ffmpeg)
			-DVTK_MODULE_ENABLE_VTK_IOGDAL=$(usex gdal YES NO)
			-DVTK_MODULE_ENABLE_VTK_IOGeoJSON=$(usex json YES NO)
			-DVTK_MODULE_ENABLE_VTK_IOXdmf2=$(usex xdmf2 YES NO)
			-DVTK_BUILD_TESTING=$(usex test ON OFF)
			# Apple stuff, does it really work?
			-DVTK_USE_COCOA=$(usex aqua)
			-DVTK_GROUP_ENABLE_Qt=YES
			# Qt5
			-DVTK_MODULE_ENABLE_VTK_ViewsCore=$(usex qt5 YES NO)
			-DVTK_MODULE_ENABLE_VTK_ViewsInfovis=$(usex qt5 YES NO)
			-DVTK_MODULE_ENABLE_VTK_ViewsContext2D=$(usex qt5 YES NO)
			-DVTK_MODULE_ENABLE_VTK_InfovisCore=$(usex qt5 YES NO)
			-DVTK_MODULE_ENABLE_VTK_InteractionStyle=$(usex qt5 YES NO)
			-DVTK_MODULE_ENABLE_VTK_ChartsCore=$(usex qt5 YES NO)
			-DVTK_MODULE_ENABLE_VTK_InteractionWidgets=$(usex qt5 YES NO)
			-DVTK_GROUP_ENABLE_Rendering=$(usex qt5 YES NO)
			# Theora/Ogg support
			-DVTK_MODULE_ENABLE_VTK_ogg=$(usex theora YES NO)
			-DVTK_MODULE_ENABLE_VTK_IOOggTheora=$(usex theora YES NO)
			# gl2ps support
			-DVTK_MODULE_ENABLE_VTK_gl2ps=$(usex gl2ps YES NO)
			-DVTK_MODULE_ENABLE_VTK_IOExportGL2PS=$(usex gl2ps YES NO)
			# MPI support
			-DVTK_GROUP_ENABLE_MPI=$(usex mpi YES NO)
			-DVTK_USE_MPI=$(usex mpi ON OFF)
			-DVTK_MODULE_ENABLE_VTK_mpi=$(usex mpi YES NO)
			# Enable the use of external libraries (if proceeds)
			$(vtk_enable_external doubleconversion)
			$(vtk_enable_external eigen)
			$(vtk_enable_external expat)
			$(vtk_enable_external freetype)
			$(vtk_enable_external gl2ps gl2ps)
			$(vtk_enable_external hdf5)
			$(vtk_enable_external jpeg)
			$(vtk_enable_external libproj)
			$(vtk_enable_external libxml2)
			$(vtk_enable_external lzma)
			$(vtk_enable_external netcdf)
			$(vtk_enable_external png)
			$(vtk_enable_external theora theora ogg)
			$(vtk_enable_external tiff)
			$(vtk_enable_external zlib)
		)


		if use java; then
			local javacargs=$(java-pkg_javac-args)
			mycmakeargs+=( -DJAVAC_OPTIONS=${javacargs// /;} )
		fi

		if use python && python_is_python3; then

			mycmakeargs+=(
				-DVTK_PYTHON_VERSION="3"
				-DPython3_EXECUTABLE="${PYTHON}"
				-DVTK_MODULE_ENABLE_VTK_mpi4py=$(usex mpi YES NO)
				-DVTK_MODULE_ENABLE_VTK_loguru=$(usex loguru YES NO)
				$(vtk_enable_external mpi mpi4py)
				$(vtk_enable_external loguru loguru)
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

	python_foreach_impl vtk_configure
}

src_compile()
{
	python_foreach_impl run_in_build_dir cmake_src_compile
}

vtk_install()
{

	use web && webapp_src_preinst

	debug-print-function ${FUNCNAME} "$@"

	cmake_src_install

	#TODO enabling MPI sets rpath to /usr/lib64; that creates QA warnings. The
	#ideal solution would be to patch this behaviour in VTK. This is a shortcut
	#fix.
	use mpi && find "${D}" -name "*lib*.so*" -exec chrpath -d {} \;

	use java && java-pkg_regjar "${ED}"/usr/$(get_libdir)/java/${PN}.jar

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

src_install() {

	python_foreach_impl vtk_install
}

# webapp.eclass exports these but we want it optional #534036
pkg_postinst() {
	use web && webapp_pkg_postinst
}

pkg_prerm() {
	use web && webapp_pkg_prerm
}

src_test() {
	vtk_test(){
		if use test; then
			einfo "Running VTK Unit Tests ..."
			pushd "${BUILD_DIR}" > /dev/null || die
			virtx ctest -j 1 -VV
			popd > /dev/null || die
		fi
	}

	python_foreach_impl vtk_test
}
