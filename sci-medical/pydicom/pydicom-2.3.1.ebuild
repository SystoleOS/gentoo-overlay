# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Python package for parsing of DICOM files"
HOMEPAGE="https://pydicom.github.io"
SRC_URI="https://github.com/pydicom/pydicom/archive/refs/tags/v2.3.1.tar.gz"

LICENSE="pydicom-MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
