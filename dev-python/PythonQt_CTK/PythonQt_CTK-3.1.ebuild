# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1

DESCRIPTION="PyhtonQt for CTK"

HOMEPAGE="https://github.com/commontk/PythonQt"

SRC_URI="https://github.com/commontk/PythonQt/archive/c4a5a155b2942d4b003862c3317105b4a1ea6755.tar.gz -> ${P}.tar.gz"

LICENSE="BSD LGPL-2"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	dev-qt/qtsvg:5
	dev-qt/designer:5
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
	${RDEPEND}
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/0001-ENH-Improve-python-detection-and-include-dirs.patch"
	"${FILESDIR}/0002-ENH-Remove-unconditionall-undefs.patch"
)

src_unpack(){

	default

	mv "${WORKDIR}"/* "${WORKDIR}"/${P}
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
