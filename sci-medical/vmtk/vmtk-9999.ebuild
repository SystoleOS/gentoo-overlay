# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit cmake-utils multilib python-r1 qmake-utils git-r3

# Short one-line description of this package.
DESCRIPTION="3D Slicer is an open source software platform for medical image informatics,
image processing, and three-dimensional visualization. This package is a
live-build which will pull the master branch of the official 3D Slicer repository."

EGIT_REPO_URI="https://github.com/vmtk/vmtk"
EGIT_BRANCH="master"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="http://vmtk.org/"

LICENSE="VTK"

SLOT="0"

KEYWORDS="~amd64"

DEPEND="
	>=sci-libs/ITK-5.0
	>=sci-libs/VTK-8.2
"

RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/0001-COMP-Adapt-vmtk-to-ITK-5.1.patch
	${FILESDIR}/0002-COMP-Remove-install-sentence-for-VMTK-Targets.patch
)

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DCMAKE_CXX_STANDARD=11
		-DCMAKE_INSTALL_PREFIX=/usr
		-DVMTK_USE_SUPERBUILD=OFF
		-DVMTK_BUILD_TESTING=OFF
		-DVTK_VMTK_INSTALL_LIB_DIR=lib64
		-DVTK_VMTK_WRAP_PYTHON=OFF
		-DVMTK_SCRIPTS_ENABLED=ON
		-DVMTK_MINIMAL_INSTALL=ON
		-DVTK_VMTK_WRAP_PYTHON=ON
		-DVTK_VMTK_CONTRIB=ON
	)

	cmake-utils_src_configure
}

pkg_postinst() {

	vmtk_python_files=$(find /usr/lib64 -name "vmtk*.py")

	pushd /usr/bin

	for i in "${vmtk_python_files}"
	do
		chmod +x ${i}
		ln -sf ${i} /usr/bin/$(basename ${i}) || die
	done

	popd
}
