# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

DESCRIPTION="Eselect module for managing PlusServer configuration files"
HOMEPAGE="https://github.com/SystoleOS"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
fi

S="${WORKDIR}"

src_unpack() {
	cp "${FILESDIR}/PlusServerConfig.eselect" "${S}/"
}

src_install() {
	insinto /usr/share/eselect/modules/
	newins "${FILESDIR}"/PlusServerConfig.eselect PlusServerConfig.eselect
}
