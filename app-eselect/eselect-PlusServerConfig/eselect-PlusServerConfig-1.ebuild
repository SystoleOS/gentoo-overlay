EAPI=7

DESCRIPTION="Eselect module for managing PlusServer configuration files"
HOMEPAGE=""
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_unpack() {
	cp "${FILESDIR}/PlusServerConfig.eselect" "${S}/"
}

src_install() {
	insinto /usr/share/eselect/modules/
	newins "${FILESDIR}"/PlusServerConfig.eselect PlusServerConfig.eselect
}
