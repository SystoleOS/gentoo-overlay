# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

inherit cmake-utils multilib git-r3

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
)

src_prepare() {

	cmake-utils_src_prepare

	to_delete=$(ls)
	mv Modules/Loadable/${PN} .
	rm -rf ${to_delete}
	mv ${PN}/* .
	rm ${PN}

}

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
		-DSlicer_QTSCRIPTEDMODULES_LIB_DIR=${WORKDIR}/qt-scripted-modules
		-DSlicer_INSTALL_QTSCRIPTEDMODULES_LIB_DIR=lib64/Slicer-4.11/qt-scripted-modules
		-DPYTHON_INCLUDE_DIR="/usr/include/python3.6m"
	)
	cmake-utils_src_configure
}

pkg_postinst(){

	pythond_libraries=$(find /usr/lib64/Slicer-4.11 -name "*${PN}*PythonD.so")
	for i in ${pythond_libraries}
	do
		ln -sf ${i} /usr/lib64/$(basename ${i}) || die
	done

	python_libraries=$(find /usr/lib64/Slicer-4.11 -name "*${PN}*Python*.so" ! -name "*${PN}*PythonD.so")
	for i in ${python_libraries}
	do
		ln -sf ${i} /usr/lib64/python3.6/site-packages/$(basename ${i}) || die
	done

	module_libraries=$(find /usr/lib64/Slicer-4.11/qt-loadable-modules -name "*${PN}*.so" ! -name "*${PN}*Python*")
	for i in ${module_libraries}
	do
		ln -sf ${i} /usr/lib64/$(basename ${i}) || die
	done

	python_libraries=$(find /usr/lib64/Slicer-4.11 -name "*${PN}*Plugin.py")
	for i in ${python_libraries}
	do
		ln -sf ${i} /usr/lib64/python3.6/site-packages/$(basename ${i}) || die
	done

}
