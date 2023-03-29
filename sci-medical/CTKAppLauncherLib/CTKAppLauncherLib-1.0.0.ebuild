# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake

# Short one-line description of this package.
DESCRIPTION="A set of common support code for medical imaging, surgical navigation, and related purposes"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.commontk.org/"

COMMIT="8759e03985738b8a8f3eb74ab516ba4e8ef29988"

SRC_URI="https://github.com/commontk/AppLauncher/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

DEPEND="dev-qt/qtcore
		dev-qt/qtwidgets"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

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

	cmake_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DCTKAppLauncher_QT_VERSION=5
		-DCTKAppLauncher_INSTALL_LauncherLibrary=ON
		-DCTK_INSTALL_LIB_DIR=lib64
		-DCTK_INSTALL_CMAKE_DIR=lib64/cmake
		# -DCTK_INSTALL_CONFIG_DIR=lib64/CTKAppLauncher-1.0.0
	)

	cmake_src_configure
}
