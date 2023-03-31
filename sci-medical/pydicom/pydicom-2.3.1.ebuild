# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python package for parsing of DICOM files"
HOMEPAGE="https://pydicom.github.io"
SRC_URI="https://github.com/pydicom/pydicom/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="pydicom-MIT"
SLOT="0"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""
