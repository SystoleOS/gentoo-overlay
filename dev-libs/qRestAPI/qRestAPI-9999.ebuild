# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=8

inherit cmake git-r3 virtualx

DESCRIPTION="qRestAPI: Tools for developing RESTful web services with Qt"
HOMEPAGE="https://github.com/commontk/qRestAPI"
LICENSE="Apache-2.0"

SLOT="0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE="-test"
RESTRICT="!test? ( test )"
EGIT_REPO_URI="https://github.com/commontk/qRestAPI.git"
EGIT_BRANCH="master"

QTMIN=5.15.8

DEPEND="
	>=dev-qt/qtcore-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtscript-${QTMIN}:5
	>=dev-qt/qttest-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-ENH-Refactor-CMake-project-infrastructure.patch"
)

src_configure() {
	local mycmakeargs=(
		-DqRestAPI_INSTALL_CMAKE_DIR:PATH=$(get_libdir)/cmake/qRestAPI
		-DqRestAPI_INSTALL_LIB_DIR:PATH=$(get_libdir)
		-DqRestAPI_INSTALL_NO_DEVELOPMENT:BOOL=OFF
		-DqRestAPI_QT_VERSION:STRING=5
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}
