# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

PYTHON_COMPAT=( python3_9 )

inherit cmake python-single-r1 git-r3

# Short one-line description of this package.
DESCRIPTION="Segmentations module for 3D-Slicer"

EGIT_REPO_URI="https://github.com/Slicer/Slicer.git"
EGIT_BRANCH="master"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://www.slicer.org/"

LICENSE="BSD"

SLOT="0"

DEPEND="
	sci-medical/Slicer
	Slicer-Loadable/SubjectHierarchy
	Slicer-Loadable/Annotations
"

RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/0001-ENH-Make-Segmentations-a-separate-module.patch
	${FILESDIR}/0002-COMP-Change-destination-dir-for-python-files.patch
	${FILESDIR}/0003-COMP-Add-missing-include-dirs-and-libraries.patch
	${FILESDIR}/0004-COMP-Adding-vtkITK-link-to-logic-segmentations.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DCMAKE_CXX_STANDARD:STRING="11"
		-DCMAKE_INSTALL_RPATH:STRING="/usr/$(get_libdir)/Slicer-4.11/qt-loadable-modules"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
		-DqSlicer${PN}ModuleWidgets_DEVELOPMENT_INSTALL:BOOL=ON
		-DvtkSlicer${PN}ModuleLogic_DEVELOPMENT_INSTALL:BOOL=ON
		-DvtkSlicer${PN}ModuleMRML_DEVELOPMENT_INSTALL:BOOL=ON
		-DvtkSlicer${PN}ModuleMRMLDisplayableManager_DEVELOPMENT_INSTALL:BOOL=ON
		-DSlicer_VTK_WRAP_HIERARCHY_DIR:STRING=${WORKDIR}
		-DSlicer_QTLOADABLEMODULES_LIB_DIR:STRING="$(get_libdir)/Slicer-4.11/qt-loadable-modules"
		-DSlicer_QTSCRIPTEDMODULES_LIB_DIR:STRING="$(get_libdir)/Slicer-4.11/qt-scripted-modules"
		-DSlicer_INSTALL_QTSCRIPTEDMODULES_LIB_DIR:STRING="$(get_libdir)/Slicer-4.11/qt-scripted-modules"
		-DPYTHON_INCLUDE_DIR:STRING="$(python_get_sitedir)"
	)

	CMAKE_USE_DIR="${WORKDIR}/${P}/Modules/Loadable/${PN}"
	cmake_src_configure
}
