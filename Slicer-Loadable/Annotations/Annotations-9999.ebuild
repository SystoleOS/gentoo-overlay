# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

inherit cmake python-single-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="3D Slicer is an open source software platform for medical image informatics,
image processing, and three-dimensional visualization. This package is a
live-build which will pull the master branch of the official 3D Slicer repository."

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="master"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

DEPEND="
	sci-medical/Slicer
	Slicer-Loadable/SubjectHierarchy
"

RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/0001-COMP-Make-the-module-a-separate-project.patch
	${FILESDIR}/0002-COMP-Add-PythonQt-include-directory.patch
	${FILESDIR}/0003-COMP-Fix-compilation-error-on-wrapping.patch
	${FILESDIR}/0004-COMP-Change-destination-dir-for-SubjectHierarchy-in-.patch
	${FILESDIR}/0005-COMP-Remove-redundant-special-functions-declarations.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DCMAKE_CXX_STANDARD=11
		-DCMAKE_INSTALL_RPATH=/usr/lib64/Slicer-4.11:/usr/lib64/ctk-0.1:/usr/lib64/Slicer-4.11/qt-loadable-modules:/usr/lib64/ITK-5.1.0
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
		-DqSlicer${PN}ModuleWidgets_DEVELOPMENT_INSTALL=ON
		-DvtkSlicer${PN}ModuleLogic_DEVELOPMENT_INSTALL=ON
		-DvtkSlicer${PN}ModuleMRML_DEVELOPMENT_INSTALL=ON
		-DvtkSlicer${PN}ModuleMRMLDisplayableManager_DEVELOPMENT_INSTALL=ON
		-DSlicer_VTK_WRAP_HIERARCHY_DIR=${WORKDIR}
		-DSlicer_INSTALL_LIB_DIR="lib64/Slicer-4.11"
		-DSlicer_QTLOADABLEMODULES_LIB_DIR=lib64/Slicer-4.11/qt-loadable-modules
		-DSlicer_QTSCRIPTEDMODULES_LIB_DIR=/lib64/Slicer-4.11/qt-scripted-modules
		-DSlicer_INSTALL_QTSCRIPTEDMODULES_LIB_DIR=lib64/Slicer-4.11/qt-scripted-modules
		-DPYTHON_INCLUDE_DIR="/usr/include/python3.6m"
	)

	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/Loadable/${PN}"
	cmake_src_configure
}
