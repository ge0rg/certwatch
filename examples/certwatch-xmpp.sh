#!/bin/bash
#
# WARNING: using "$0" is unreliable, maybe replace with bashism instead?
source $(dirname "$0")/../certwatch.sh

# check the HTTPS certificates
check_https xmpp.org
check_https www.xmpp.org

# xmpp.org client connections hosted on xmpp.xmpp.org:9222
check_xmpp xmpp.org xmpp.xmpp.org 9222

# xmpp.org and muc.xmpp.org server connections hosted on xmpp.xmpp.org:9269
check_xmpp xmpp.org xmpp.xmpp.org 9269 xmpp-server
check_xmpp muc.xmpp.org xmpp.xmpp.org 9269 xmpp-server

