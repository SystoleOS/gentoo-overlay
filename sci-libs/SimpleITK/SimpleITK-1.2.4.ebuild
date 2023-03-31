# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-single-r1

DESCRIPTION="SimpleITK: Simplifying and facilitating rapid prototyping with ITK"

HOMEPAGE="https://github.com/SimpleITK/SimpleITK"

SRC_URI="https://github.com/SimpleITK/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi
SLOT="0"

DEPEND="
	dev-lang/python
	>=dev-lang/lua-5.1
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/0001-ENH-Adding-installation-directory-for-python-module.patch"
)

src_unpack() {

	# Unpack ITK source code
	if [ "${A}"  != "" ]; then
		unpack ${A}
	fi
	mv "${WORKDIR}"/"${PN}"-"${COMMIT}" "${WORKDIR}"/"${PN}"-"${PV}"
}

src_configure() {

	local mycmakeargs=()

	# General building options
	mycmakeargs+=(
		-DBUILD_TESTING:BOOL=OFF
		-DWRAP_LUA:BOOL=OFF
		-DWRAP_JAVA:BOOL=OFF
		-DWRAP_PYTHON:BOOL=ON
		-DSKBUILD:BOOL=ON
		-DSimpleITK_INSTALL_LIBRARY_DIR:STRING="$(get_libdir)"
		-DSimpleITK_INSTALL_ARCHIVE_DIR:STRING="$(get_libdir)"
		-DSimpleITK_INSTALL_PYTHON_LIBRARY_DIR:STRING="$(python_get_sitedir)"
	)

	cmake_src_configure
}
