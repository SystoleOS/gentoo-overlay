# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )

inherit cmake python-single-r1

DESCRIPTION="PyhtonQt for CTK"

HOMEPAGE="https://github.com/commontk/PythonQt"

SRC_URI="https://github.com/commontk/PythonQt/archive/c4a5a155b2942d4b003862c3317105b4a1ea6755.zip -> ${P}.zip"

LICENSE="BSD LGPL-2"
KEYWORDS="~amd64"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtmultimedia
	dev-qt/qtsvg
	dev-qt/designer
	!dev-python/PythonQt
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
	${RDEPEND}
	app-arch/unzip
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	${FILESDIR}/0001-ENH-Improve-python-detection-and-include-dirs.patch
	${FILESDIR}/0002-ENH-Remove-unconditionall-undefs.patch
)

src_unpack(){

	default

	mv ${WORKDIR}/* ${WORKDIR}/${P}
}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {

	local mycmakeargs=()

	# General building options
	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DPythonQt_INSTALL_LIBRARY_DIR=$(get_libdir)
		-DPythonQt_QT_VERSION=5
		-DPython3_INCLUDE_DIR:FILEPATH=$(python_get_includedir)
		-DPythonQt_Wrap_QtAll=ON
	)

	cmake_src_configure
}
