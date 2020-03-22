# Copyright @ 2019 Oslo University Hospital. All rights reserved.

EAPI=7

inherit cmake-utils git-r3

# Short one-line description of this package.
DESCRIPTION="Client side integration libraries for AI-Assisted Annotation SDK"

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/NVIDIA/ai-assisted-annotation-client"

EGIT_REPO_URI="https://github.com/NVIDIA/ai-assisted-annotation-client.git"
EGIT_BRANCH="master"

LICENSE="NVIDIA"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND="
	dev-cpp/nlohmann_json
	dev-libs/poco
"

RDEPEND="${DEPEND}"

PATCHES=(${FILESDIR}/test.patch)

# src_unpack() {

# 	# Unpack ITK source code if [ "${A}" != "" ]; then unpack ${A} fi mv
# 	${WORKDIR}/${PN}-${COMMIT} ${WORKDIR}/${PN}-${PV}

# 	# Inject ITKImageIO remote module unpack
# 	${FILESDIR}/itkMGHImageIO-master.zip pushd ${WORKDIR}/itkMGHImageIO
# 	|| die git init popd || die

# 	# Inject ITKThickness3D remote module unpack
# 	${FILESDIR}/ITKThickness3D.zip pushd ${WORKDIR}/ITKThickness3D ||
# 	die git init popd || die }

src_prepare() {

	cmake-utils_src_prepare
}

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
		-DUSE_SUPERBUILD=OFF
		-DNvidiaAIAAClient_ARCHIVE_DIR=/usr/lib64
		-DNvidiaAIAAClient_LIBRARIES_DIR=/usr/lib64
		-DNvidiaAIAAClient_CMAKE_DIR=/usr/lib64/cmake
	)

	cmake-utils_src_configure
}
