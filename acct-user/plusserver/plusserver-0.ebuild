EAPI=7

inherit acct-user

DESCRIPTION="User for PlusServer"
ACCT_USER_ID=251
ACCT_USER_GROUPS=( "plusserver" )
ACCT_USER_HOME=/var/lib/plusserver
ACCT_USER_SHELL=/sbin/nologin

acct-user_add_deps
