# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit multibuild python-r1 qmake-utils cmake-utils

# Short one-line description of this package.
DESCRIPTION="The Visualization Toolkit"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Slicer/VTK/"

COMMIT="73e89e85c49c0802a77b208e8a973e566bc8b6f4"

SRC_URI="https://github.com/Slicer/VTK/archive/${COMMIT}.zip -> ${PN}-${PV}.zip"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="~amd64"

IUSE="python"

RDEPEND="
	${PYTHON_DEPS}
	>dev-cpp/eigen-3.3
	dev-qt/qtx11extras
	dev-qt/qtwebengine[widgets]
	dev-qt/qtsql
	dev-qt/designer[webkit]
	x11-libs/libXt
"

DEPEND="${RDEPEND}"

IUSE="python"

PATCHES=(
	${FILESDIR}/${PN}-${PV}-0001-ENH-Include-vtkEventData.h-in-module-headers-vtkComm.patch
)

src_unpack() {

	# Un pack source  code package
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi

	mv ${WORKDIR}/${PN}-${COMMIT} ${WORKDIR}/${PN}-${PV}

	# Unpack SplineDrivenImageSlicer
	unpack ${FILESDIR}/SplineDrivenImageSlicer.zip
	mv ${WORKDIR}/SplineDrivenImageSlicer ${WORKDIR}/${PN}-${PV}/Remote
}

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	configure() {

		local mycmakeargs=(
			-DBUILD_EXAMPLES=OFF
			-DBUILD_TESTING=OFF
			-DBUILD_SHARED_LIBS=ON
			-DVTK_BUILD_ALL_MODULES=OFF
			-DVTK_ENABLE_KITS=ON
			-DVTK_Group_Qt=ON
			-DVTK_LEGACY_REMOVE=OFF
			-DVTK_QT_VERSION=5
			-DVTK_RENDERING_BACKEND=OpenGL2
			-DVTK_WRAP_PYTHON:BOOL="$(usex python ON OFF)"
			-DModule_vtkGUISupportQt=ON
			-DModule_vtkGUISupportQtOpenGL=ON
			-DModule_vtkGUISupportQtSQL=ON
			-DModule_vtkGUISupportQtWebkit=OFF
			-DModule_vtkIOExport=ON
			-DModule_vtkIOGeometry=ON
			-DModule_vtkIOInfovis=ON
			-DModule_vtkIOPLY=On
			-DVTK_Group_StandAlone=ON
			-DVTK_Group_Rendering=OFF
			-DModule_vtkImagingMorphological=ON
			-DModule_vtkImagingStatistics=ON
			-DModule_vtkImagingStencil=ON
			-DModule_vtkInteractionImage=ON
			-DModule_vtkRenderingFreeTypeFontConfig=ON
			-DModule_vtkRenderingQt=ON
			-DModule_vtkTestingRendering=ON
			-DModule_vtkViewsContext2D=ON
			-DModule_vtkFiltersFlowPaths=ON
			-DModule_vtkGUISupportQtOpenGL=ON
			-DModule_SplineDrivenImageSlicer=ON
			-DVTK_USE_SYSTEM_EIGEN=ON
		)

		cmake-utils_src_configure
	}

	python_foreach_impl run_in_build_dir configure
}
