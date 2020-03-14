# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils

# Short one-line description of this package.
DESCRIPTION="A set of common support code for medical imaging, surgical navigation, and related purposes"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.commontk.org/"

COMMIT="ec98a50327644f6607b1a21bf016eba1027134d5"

SRC_URI="https://github.com/commontk/AppLauncher/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="dev-qt/qtcore
		dev-qt/qtwidgets"
RDEPEND="${DEPEND}"

PATCHES=()

src_unpack() {
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi

	mv ${WORKDIR}/AppLauncher-${COMMIT} ${WORKDIR}/${PN}-${PV}
	pushd ${WORKDIR}/${PN}-${PV} || die
	git init
	popd || die
}

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DCTKAppLauncher_QT_VERSION=5
		-DCTKAppLauncher_INSTALL_LauncherLibrary=ON
		-DCTK_INSTALL_LIB_DIR=lib64/CTKAppLauncher-1.0.0
		-DCTK_INSTALL_CMAKE_DIR=lib64/CTKAppLauncher-1.0.0/CMake
		-DCTK_INSTALL_CONFIG_DIR=lib64/CTKAppLauncher-1.0.0
	)

	cmake-utils_src_configure
}
