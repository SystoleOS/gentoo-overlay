# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

inherit acct-user

DESCRIPTION="User for PlusServer"
ACCT_USER_ID=251
ACCT_USER_GROUPS=( "plusserver" )
ACCT_USER_HOME=/var/lib/plusserver
ACCT_USER_SHELL=/sbin/nologin

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ppc ppc64 s390 sparc x86"

acct-user_add_deps
