# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Pure JavaScript plotting plugin for jQuery"
HOMEPAGE="http://www.jqplot.com"

SRC_URI="http://slicer.kitware.com/midas3/download?items=15065&dummy=jquery.jqplot.1.0.4r1120.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~arm ~x86 ~x64-macos"


src_unpack(){
	default

	mv ${WORKDIR}/* ${WORKDIR}/${P} || die
}

src_install(){
	insinto /usr/share/jqPlot
	insopts -m0755
	doins "${S}"/*

	insinto /usr/share/jqPlot/plugins
	insopts -m0755
	doins "${S}"/plugins/*
}
