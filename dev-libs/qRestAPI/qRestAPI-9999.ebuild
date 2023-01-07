EAPI=8

inherit cmake git-r3

DESCRIPTION="Simple Qt library allowing to synchronously or asynchronously query a REST server"
HOMEPAGE="https://github.com/commontk/qRestAPI"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64"

EGIT_REPO_URI="https://github.com/commontk/qRestAPI.git"
EGIT_BRANCH="master"

DEPEND="
	dev-qt/qtcore
    dev-qt/qtgui
    dev-qt/qtnetwork
    dev-qt/qtscript
    dev-qt/qttest
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
    ${FILESDIR}/0001-ENH-Update-cmake-requirements.patch
    ${FILESDIR}/0002-ENH-Remove-the-use-of-Qt4.patch
    ${FILESDIR}/0003-ENH-Refactor-CMake-project-definition.patch
)

src_configure(){

	local mycmakeargs=()

	mycmakeargs+=(
        -DqRestAPI_INSTALL_CMAKE_DIR:PATH=$(get_libdir)/cmake/qRestAPI
        -DqRestAPI_INSTALL_LIB_DIR:PATH=$(get_libdir)
        -DqRestAPI_INSTALL_NO_DEVELOPMENT:BOOL=OFF
        )
	cmake_src_configure
}
