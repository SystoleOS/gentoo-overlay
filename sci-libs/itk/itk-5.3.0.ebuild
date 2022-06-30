# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit cmake python-single-r1 git-r3

# Package information
MY_PN="InsightToolkit"
MY_P="${MY_PN}-${PV}"

# ITK Remotes
ITKAdaptiveDenoising_HASH="674218fae611184d4168bd0c7b027f1a0d1a8a18"
ITKMGHImageIO_HASH="74379a6350f8017be2b4481c807726d56fec14bb"
ITKIOScanco_HASH="348ca2eb519cf11c976884fb792ec1b0a08a277a"
ITKMorphologicalContourInterpolator_HASH="44854a462309ca902d2d21a18dca50f777b9f6a5"

# source code URIs
SRC_URI="
  https://github.com/ntustison/ITKAdaptiveDenoising/archive/${ITKAdaptiveDenoising_HASH}.zip
  https://github.com/InsightSoftwareConsortium/itkMGHImageIO/archive/${ITKMGHImageIO_HASH}.zip
  https://github.com/KitwareMedical/ITKIOScanco/archive/${ITKIOScanco_HASH}.zip
  https://github.com/KitwareMedical/ITKMorphologicalContourInterpolation/archive/${ITKMorphologicalContourInterpolator_HASH}.zip
"


DESCRIPTION="NLM Insight Segmentation and Registration Toolkit"
HOMEPAGE="http://www.itk.org"

EGIT_REPO_URI="https://github.com/Slicer/ITK"
EGIT_BRANCH="slicer-v5.3rc03-2022-02-10-be81e62"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug deprecated doc examples fftw python review -test +vtkglue"

RESTRICT="!test? ( test )"

RDEPEND="
  dev-libs/double-conversion:0=
  media-libs/openjpeg:2
  media-libs/libpng:0=
  media-libs/tiff:0=
  sci-libs/dcmtk:0=
  sci-libs/hdf5:0=[cxx]
  sys-libs/zlib:0=
  media-libs/libjpeg-turbo:0=
  fftw? ( sci-libs/fftw:3.0= )
  vtkglue? ( >=sci-libs/vtk-9.1.0[rendering,python?] )
  python? ( ${PYTHON_DEPS} )
  sci-medical/gdcm
  dev-cpp/eigen
"
DEPEND="${RDEPEND}
  sys-apps/coreutils
  python? (
    >=dev-lang/swig-2.0:0
    dev-cpp/castxml
  )
  doc? ( app-doc/doxygen )
"
BDEPEND="app-arch/unzip"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/itk-${PV}"

PATCHES=()

src_unpack() {

  #Unpack ITKAdaptiveDenoising
  unzip ${DISTDIR}/${ITKAdaptiveDenoising_HASH}.zip || die
  unzip ${DISTDIR}/${ITKMGHImageIO_HASH}.zip || die
  unzip ${DISTDIR}/${ITKIOScanco_HASH}.zip || die
  unzip ${DISTDIR}/${ITKMorphologicalContourInterpolator_HASH}.zip || die

  #NOTE: This ebuild has the particularity that it uses both git and source
  #files. Therefore we need to call the src_unpack function from the git module
  git-r3_src_unpack
}
src_prepare() {

  sed -i -e "s/find_package(OpenJPEG 2.0.0/find_package(OpenJPEG/g"\
    Modules/ThirdParty/GDCM/src/gdcm/CMakeLists.txt

  # Symlinking external ITKAdaptiveDenoising
  ln -sr ../ITKAdaptiveDenoising-* Modules/Remote/ITKAdaptiveDenoising || die
  ln -sr ../ITKMGHImageIO-* Modules/Remote/ITKMGHImageIO || die
  ln -sr ../ITKIOScanco-* Modules/Remote/ITKIOScanco || die
  ln -sr ../ITKMorphologicalContourInterpolation-* Modules/Remote/ITKMorphologicalContourInterpolation || die

  cmake_src_prepare
}
src_configure() {
  local mycmakeargs=(
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING="$(usex test ON OFF)"
    -DBUILD_EXAMPLES="$(usex examples ON OFF)"
    -DITK_USE_REVIEW="$(usex review ON OFF)"
    -DITK_BUILD_DOCUMENTATION="$(usex doc ON OFF)"
    -DITK_INSTALL_LIBRARY_DIR=$(get_libdir)

    # ITK Modules
    -DITK_BUILD_DEFAULT_MODULES:BOOL=ON
    -DModule_ITKReview:BOOL=ON
    -DModule_MGHIO:BOOL=ON
    -DModule_ITKIOMINC:BOOL=ON
    -DModule_IOScanco:BOOL=ON
    -DModule_MorphologicalContourInterpolation:BOOL=ON
    -DModule_SimpleITKFilters:BOOL=${Slicer_USE_SimpleITK}
    -DModule_GenericLabelInterpolator:BOOL=ON
    -DModule_AdaptiveDenoising:BOOL=ON
    -DModule_ITKVtkGlue:BOOL=$(usex vtkglue ON OFF)
    -DModule_ITKDeprecated:BOOL=$(usex deprecated ON OFF)
    -DITK_INSTALL_NO_DEVELOPMENT:BOOL=ON
    -DKWSYS_USE_MD5:BOOL=ON # Required by SlicerExecutionModel
    -DITK_WRAPPING:BOOL=OFF #${BUILD_SHARED_LIBS} ## HACK:  QUICK CHANGE
    -DITK_WRAP_PYTHON:BOOL=${Slicer_BUILD_ITKPython}
    -DExternalData_OBJECT_STORES:PATH=${ExternalData_OBJECT_STORES}
    -DITK_USE_SYSTEM_EIGEN:BOOL=ON

    # VTK
    -DModule_ITKVtkGlue:BOOL=ON

    # DCMTK
    -DITK_USE_SYSTEM_DCMTK:BOOL=ON
    -DDCMTK_DIR:PATH=${DCMTK_DIR}
    -DModule_ITKIODCMTK:BOOL=${Slicer_BUILD_DICOM_SUPPORT}

    # ZLIB
    -DITK_USE_SYSTEM_ZLIB:BOOL=ON

    -DGDCM_USE_SYSTEM_OPENJPEG=ON
    -DITK_FORBID_DOWNLOADS:BOOL=ON
    -DITK_USE_SYSTEM_DCMTK=ON
    -DITK_USE_SYSTEM_DOUBLECONVERSION=ON
    -DITK_USE_SYSTEM_CASTXML=ON
    -DITK_USE_SYSTEM_HDF5=ON
    -DITK_USE_SYSTEM_JPEG=ON
    -DITK_USE_SYSTEM_PNG=ON
    -DITK_USE_SYSTEM_SWIG=ON
    -DITK_USE_SYSTEM_TIFF=ON
    -DITK_USE_SYSTEM_ZLIB=ON
    -DITK_USE_KWSTYLE=OFF
    -DITK_BUILD_DEFAULT_MODULES=ON
    -DITK_COMPUTER_MEMORY_SIZE="${ITK_COMPUTER_MEMORY_SIZE:-1}"
    -DWRAP_ITK_JAVA=OFF
    -DWRAP_ITK_TCL=OFF
    -Ddouble-conversion_INCLUDE_DIRS="${EPREFIX}/usr/include/double-conversion"
  )

  if use fftw; then
    mycmakeargs+=(
      -DUSE_FFTWD=ON
      -DUSE_FFTWF=ON
      -DUSE_SYSTEM_FFTW=ON
      -DITK_WRAP_double=ON
      -DITK_WRAP_vector_double=ON
      -DITK_WRAP_covariant_vector_double=ON
      -DITK_WRAP_complex_double=ON
    )
  fi

  if use python; then
    mycmakeargs+=(
      -DITK_WRAP_PYTHON=ON
      -DITK_WRAP_DIMS="${ITK_WRAP_DIMS:-2;3}"
    )
  else
    mycmakeargs+=(
      -DITK_WRAP_PYTHON=OFF
    )
  fi
  cmake_src_configure
}

src_install() {
  cmake_src_install

  if use examples; then
    docinto examples
    docompress -x /usr/share/doc/${PF}/examples
    dodoc -r "${S}"/Examples/*
  fi

  echo "ITK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data" > ${T}/40${PN}
  local ldpath="${EPREFIX}/usr/$(get_libdir)/InsightToolkit"
  if use python; then
    echo "PYTHONPATH=${EPREFIX}/usr/$(get_libdir)/InsightToolkit/WrapITK/Python" >> "${T}"/40${PN}
    ldpath="${ldpath}:${EPREFIX}/usr/$(get_libdir)/InsightToolkit/WrapITK/lib"
  fi
  echo "LDPATH=${ldpath}" >> "${T}"/40${PN}
  doenvd "${T}"/40${PN}

  if use doc; then
    cd "${WORKDIR}"/html || die
    rm  *.md5 || die "Failed to remove superfluous hashes"
    einfo "Installing API docs. This may take some time."
    docinto api-docs
    dodoc -r *
  fi
}

pkg_postinst(){

	libraries=$(find /usr/lib64 -name "libitk*.so")
	for i in ${libraries}
	do
        b=$(basename $i)
		ln -sf $i /usr/lib64/${b%-*}.so || die
	done

}
