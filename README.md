# certwatch.sh

This is a cronjob script to check a list of services for valid TLS certificates.

License: MIT

## Configuration Example

Example to periodically check the XMPP Standards Foundation's XMPP and HTTPS services, 
`certwatch-xmpp.sh`:

```bash
source certwatch/certwatch.sh

# check the HTTPS certificates
check_https xmpp.org
check_https www.xmpp.org

# xmpp.org client connections hosted on xmpp.xmpp.org:9222
check_xmpp xmpp.org xmpp.xmpp.org 9222

# xmpp.org and muc.xmpp.org server connections hosted on xmpp.xmpp.org:9269
check_xmpp xmpp.org xmpp.xmpp.org 9269 xmpp-server
check_xmpp muc.xmpp.org xmpp.xmpp.org 9269 xmpp-server
```

Add the following line to your crontab to run the script every morning:

```
15 7 * * * /path/to/certwatch-xmpp.sh
```

## Output examples

If the certificates are good, the script doesn't output anything.

If the certificates are going to expire, the script outputs a text block for
each certificate:

```
-------------------- -connect xmpp.xmpp.org:9222 -xmpphost xmpp.org -starttls xmpp
        Issuer: C = US, O = Let's Encrypt, CN = R3
            Not After : Apr 18 04:26:04 2021 GMT
        Subject: CN = xmpp.org
                DNS:xmpp.org
Verification: OK
------------------------------------------------------------
-------------------- -connect xmpp.xmpp.org:9269 -xmpphost xmpp.org -starttls xmpp-server
        Issuer: C = US, O = Let's Encrypt, CN = R3
            Not After : Apr 18 04:26:04 2021 GMT
        Subject: CN = xmpp.org
                DNS:xmpp.org
Verification: OK
------------------------------------------------------------
-------------------- -connect xmpp.xmpp.org:9269 -xmpphost muc.xmpp.org -starttls xmpp-server
        Issuer: C = US, O = Let's Encrypt, CN = R3
            Not After : Apr 18 04:25:50 2021 GMT
        Subject: CN = muc.xmpp.org
                DNS:muc.xmpp.org
Verification: OK
------------------------------------------------------------
```

## TODOs

 - [ ] implement SRV lookup for XMPP
 - [ ] make 14 day warning interval configurable
 - [ ] make script independent of BASH
