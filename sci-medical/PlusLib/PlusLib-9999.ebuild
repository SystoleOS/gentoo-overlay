# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit cmake git-r3 systemd

DESCRIPTION="Software library for data acquisition, pre-processing, and calibration for navigated image-guided interventions"
HOMEPAGE="https://www.plustoolkit.org/"
EGIT_REPO_URI="https://github.com/PlusToolkit/PlusLib"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="OpenIGTLink systemd tools widgets"

DEPEND="
	sci-libs/vtk:0=
	sci-libs/vtkAddon
	sci-medical/IGSIO[volume-reconstruction]
	sci-medical/OpenIGTLink
	sci-medical/OpenIGTLinkIO
	tools? (
		acct-group/plusserver
		acct-user/plusserver
		sys-apps/systemd
		)
"

RDEPEND="
	${DEPEND}
"

PATCHES=(
	${FILESDIR}/0001-ENH-Fix-compile-using-install-tree-of-dependencies.patch
	${FILESDIR}/0002-ENH-Modify-loading-of-configuration-to-fit-system-in.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		# TODO: This should be fixed in VTK so we don't need to specify the VTK_DIR or ITK_DIR
		-DVTK_DIR:STRING=/usr/lib64/cmake/vtk-9.1
		-DITK_DIR:STRING=/usr/lib64/cmake/ITK-5.4
		-DOpenIGTLinkIO_DIR:FILEPATH=/usr/lib64/cmake/igtlio
		-DPLUS_USE_OpenIGTLink:BOOL=$(usex OpenIGTLink ON OFF)
		-DPLUS_BUILD_WIDGETS:BOOL=$(usex widgets ON OFF)
		# NOTE: This needs to be in sync with PlusApp-9999.ebuild
		-DPLUSLIB_APPLICATION_DEFAULT_CONFIG_FILE:FILEPATH=/etc/PlusApp/PlusConfig.xml
		-DPLUSBUILD_BUILD_PlusLib_TOOLS:BOOL=$(usex tools ON OFF)
		-DPLUS_RENDERING_ENABLED:BOOL=ON
		)

		if use OpenIGTLink; then
			mycmakeargs+=(
				-DOpenIGTLink_DIR:FILEPATH=/usr/lib64/cmake/igtl-3.1
			)
		fi

	cmake_src_configure
}

src_install() {

	cmake_src_install

	# Install the simulated-tracker.xml configuration file
	insinto /etc/PlusServer
	doins "${FILESDIR}"/simulated-tracker.xml
	dosym /etc/PlusServer/simulated-tracker.xml /etc/PlusServer/current-config.xml

	if use systemd; then
		systemd_dounit "${FILESDIR}"/PlusServer.service
	fi
}
