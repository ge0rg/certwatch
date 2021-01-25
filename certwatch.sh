#!/bin/bash
#
# cronjob script to check all your servers' certificates. Goals:
#
#  - advance warning of certificate expiration (14 days)
#  - warning of failed verifications
#


# Check a given TLS service and emit a text block if TLS verification fails or
# the certificate is going to expire soon.
#
# Parameters: same as openssl s_client to establish a connection
#
# Output: nothing on success, "informative" text block on failure
check_service() {
	DAYS=14
	# obtain certificate, mute well-known stderr output
	CRT=$(openssl s_client "$@" </dev/null 2> >(egrep -v '^(depth|verify|DONE|250)' 1>&2))
	# extract potential verification failure
	VERIFICATION=$(echo "$CRT" | grep "^Verification:")
	FAIL=$(echo "$VERIFICATION" | grep -v "^Verification: OK")
	echo "$CRT" | openssl x509 -noout -checkend $(($DAYS*3600*24)) >/dev/null 2>&1 && [ -z "$FAIL" ] && return
	echo "-------------------- $@"
	echo "$CRT" | openssl x509 -noout -text|egrep 'CN|DNS|Not After' 2>/dev/null
	echo "$VERIFICATION"
	echo "------------------------------------------------------------"
}

# Wrapper for check_service to test an HTTPS service on port 443
#
# Parameter: hostname to test on :443
check_https() {
	check_service -servername $1 -connect $1:443
}

# Wrapper for check_service to test a "STARTTLS" SMTP client port
#
# Parameter: hostname to test on :25
check_smtp() {
	check_service -connect $1:25 -starttls smtp
}

# Wrapper for check_service to test a "STARTTLS" XMPP client port. Requires OpenSSL 1.1
#
# TODO: implement SRV lookups
#
# Parameters:
#  - service domain (required)
#  - server hostname (defaults to service domain)
#  - port (default: 5222)
#  - starttls (default: "xmpp", alternative: "xmpp-server")
check_xmpp() {
	DOMAIN="$1"
	HOST="$2"
	PORT="${3:-5222}"
	STARTTLS="${4:-xmpp}"
	if [ "$HOST" ] ; then
		XMPPHOST="-xmpphost $DOMAIN"
	else
		XMPPHOST=""
		HOST="$DOMAIN"
	fi
	check_service -connect "$HOST:$PORT" $XMPPHOST -starttls "$STARTTLS"
}

