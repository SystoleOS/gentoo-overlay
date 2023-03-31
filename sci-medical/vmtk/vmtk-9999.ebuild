# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="The Vascular Modeling Toolkit"

EGIT_REPO_URI="https://github.com/vmtk/vmtk"
EGIT_BRANCH="master"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://vmtk.org/"

LICENSE="BSD"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"

DEPEND="
	dev-lang/python[tk]
	>=sci-libs/itk-5.0
	>=sci-libs/vtk-9.2
"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/0001-COMP-Adapt-vmtk-to-ITK-5.1.patch"
	"${FILESDIR}/0002-COMP-Remove-install-sentence-for-VMTK-Targets.patch"
	"${FILESDIR}/0003-ENH-Change-variables-definition-check.patch"
)

src_prepare() {

	cmake_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DCMAKE_CXX_STANDARD:STRING="17"
		-DVMTK_USE_SUPERBUILD:BOOL=OFF
		-DVMTK_BUILD_TESTING:BOOL=OFF
		-DVMTK_INSTALL_LIB_DIR:FILEPATH=$(get_libdir)
		-DVTK_VMTK_INSTALL_LIB_DIR:FILEPATH=$(get_libdir)
		-DVMTK_SCRIPTS_INSTALL_LIB_DIR:FILEPATH=$(python_get_sitedir)/vmtk
		-DVMTK_CONTRIB_SCRIPTS_INSTALL_LIB_DIR:FILEPATH=$(python_get_sitedir)/vmtk
		-DPYPES_MODULE_INSTALL_LIB_DIR:FILEPATH=$(python_get_sitedir)/vmtk
		-DVMTK_SCRIPTS_ENABLED:BOOL=ON
		-DVMTK_MINIMAL_INSTALL:BOOL=ON
		-DVTK_VMTK_WRAP_PYTHON:BOOL=ON
		-DVMTK_WRAP_PYTHON:BOOL=ON
		-DVTK_VMTK_CONTRIB:BOOL=ON
		-DVMTK_USE_RENDERING:BOOL=ON
	)

	cmake_src_configure
}

pkg_postinst() {

	# TODO: This probably needs to be replaced by proper installation of files
	vmtk_python_files=$(find /usr/lib64 -name "vmtk*.py")

	pushd /usr/bin

	for i in ${vmtk_python_files}
	do
		chmod +x ${i}
		ln -sf ${i} /usr/bin/$(basename ${i} .py) || die
	done

	popd
}
