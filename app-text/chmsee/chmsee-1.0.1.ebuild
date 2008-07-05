# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="Utility for viewing Microsoft .chm files."
HOMEPAGE="http://chmsee.gro.clinux.org"
SRC_URI="http://gro.clinux.org/frs/download.php/2245/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

IUSE="xulrunner"
RDEPEND=">=gnome-base/libglade-2.0
	>=x11-libs/gtk+-2.8
	dev-libs/chmlib
	dev-libs/openssl
	xulrunner? ( || ( =net-libs/xulrunner-1.8*
		=net-libs/xulrunner-bin-1.8.1.15 ) )
	!xulrunner? ( >=www-client/mozilla-firefox-1.5.0.7 )"

DEPEND="${RDEPEND}"

src_compile() {
	local myconf
	if use xulrunner; then
		myconf="${myconf} --with-gecko=xulrunner"
	else
		if has_version '=www-client/mozilla-firefox-3*'; then
			elog "Please enable 'xulrunner' USE flag since chmsee depends on"
			elog "xulrunner-1.8, while mozilla-firefox-3 pulls in xulrunner-1.9."
			die
		else
			myconf="${myconf} --with-gecko=firefox"
		fi
	fi

	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README
}
