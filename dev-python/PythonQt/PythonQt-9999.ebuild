# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3

DESCRIPTION="PyhtonQt for CTK"

HOMEPAGE="https://github.com/commontk/PythonQt"

#SRC_URI="https://github.com/commontk/PythonQt/archive/8462a54a3281aff550730530c999cee4eb453bea.zip -> ${P}.zip"
EGIT_REPO_URI="https://github.com/commontk/PythonQt"
EGIT_BRANCH="patched-10"

LICENSE="BSD LGPL-2"
KEYWORDS="~amd64 ~arm x86 ~amd64-linux ~x86-linux"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
"

RDEPEND="${DEPEND}"

# src_unpack(){

# 	default

# 	mv ${WORKDIR}/* ${WORKDIR}/${P}
# }

src_configure() {

	local mycmakeargs=()

	# General building options
	mycmakeargs+=(
		-DBUILD_TESTING=OFF
		-DPythonQt_INSTALL_LIBRARY_DIR=$(get_libdir)
		-DPythonQt_QT_VERSION=5
		-DQT_QMAKE_EXECUTABLE=/usr/lib64/qt5/bin/qmake
	)

	# PythonQt Wrapping
	mycmakeargs+=(
		-DPythonQt_Wrap_QtAll=ON
	)

	cmake-utils_src_configure
}
