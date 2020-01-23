# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils

# Short one-line description of this package.
DESCRIPTION="Insight Segmentation and Registratio Toolkit for Slicer"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/ITK/"

COMMIT="c4011006034be69a732fd519fe42e5966c52dedf"

SRC_URI="https://github.com/Slicer/SlicerExecutionModel/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="3D-Slicer"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND=""

RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/0001-ENH-Fix-path-to-install-ModuleDescriptionParserConfi.patch
	${FILESDIR}/0002-ENH-Remove-_install-from-.cmake_install-extension-in.patch
	${FILESDIR}/0003-ENH-Add-section-to-install-support-files-in-SlicerEx.patch
	${FILESDIR}/0004-ENH-Generate-configuration-file-for-install-ModuleDe.patch
	${FILESDIR}/0005-ENH-Generate-TCLAP-install-configuration-files.patch
	${FILESDIR}/0006-COMP-Fix-path-to-GenerateCLPConfig-for-install-tree.patch
	${FILESDIR}/0007-COMP-Add-the-SlicerExecutionModel_INSTALL_LIB_DIR-va.patch
	${FILESDIR}/0008-COMP-Remove-not-needed-SlicerExecutionModel_INCLUDE_.patch
	${FILESDIR}/0009-COMP-Modify-relative-path-for-ModuleDescriptionParse.patch
	${FILESDIR}/0010-COMP-Install-GenerateInstallCLPConfig.cmake-install-.patch
	${FILESDIR}/0011-COMP-Install-GenerateCLP.cmake-GenerateCLP-and-Gener.patch
	${FILESDIR}/0012-COMP-Fix-UseGenerateCLP.patch
	${FILESDIR}/0013-COMP-Fix-path-to-GenerateCLP-executable.patch
	${FILESDIR}/0014-COMP-Enable-automatic-inclusion-of-use-file-and-link.patch
	${FILESDIR}/0015-COMP-Fix-path-to-SEMCommandLineLibraryWrapper.cxx.patch
	${FILESDIR}/0016-COMP-Add-INSTALL_RPATH-property-to-CLI-exes-to-be-ab.patch
	${FILESDIR}/0017-ENH-Adding-path-to-libITKFactoryRegistration.so-CLP-.patch
)

src_unpack() {

	# Unpack ITK source code
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi
	mv ${WORKDIR}/${PN}-${COMMIT} ${WORKDIR}/${PN}-${PV}

}

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DBUILD_SHARED_LIBS=ON
		-DTCLAP_INSTALL_NO_DEVELOPMENT=OFF
		-DSlicerExecutionModel_INSTALL_BIN_DIR=/usr/bin
		-DSlicerExecutionModel_INSTALL_LIB_DIR=/usr/lib64/SlicerExecutionModel-1.0.0
		-DSlicerExecutionModel_INSTALL_NO_DEVELOPMENT=OFF
		-DSlicerExecutionModel_DEFAULT_CLI_INSTALL_LIBRARY_DESTINATION=lib64
		-DSlicerExecutionModel_DEFAULT_CLI_INSTALL_ARCHIVE_DESTINATION=lib64
	)

	cmake-utils_src_configure
}
