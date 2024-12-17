#!/bin/bash

### Script installs root.cert.pem to certificate trust store of applications using NSS
### (e.g. Firefox, Thunderbird, Chromium)
### Mozilla uses cert8, Chromium and Chrome use cert9

### Requirement: apt install libnss3-tools
###
### Input: Certificate URL is passed as environment variable CERTIFICATE_PATH.

# Validate input
if [[ -z "$CERTIFICATE_PATH" ]]; then
    echo "ERROR: No certificate file provided. Pass a certificate file path."
    exit 1
fi

# Validate certificate file exists
if [[ ! -f "$CERTIFICATE_PATH" ]]; then
    echo "ERROR: Certificate file does not exist: $CERTIFICATE_PATH"
    exit 1
fi

echo "Processing certificate: $CERTIFICATE_PATH"

# For cert8 (legacy - DBM)
for certDB in $(find ~/ -name "cert8.db"); do
    certdir=$(dirname ${certDB})
    certname=$(basename ${CERTIFICATE_PATH})
    echo "Importing certificate to Firefox trust store at: ${certdir}"
    certutil -A -n "$certname" -t "TCu,Cu,Tu" -i "${CERTIFICATE_PATH}" -d dbm:${certdir}
done

# For cert9 (SQL)
for certDB in $(find ~/ -name "cert9.db"); do
    certdir=$(dirname ${certDB})
    certname=$(basename ${CERTIFICATE_PATH})
    echo "Importing certificate to Chromium/Chrome trust store at: ${certdir}"
    certutil -A -n "$certname" -t "TCu,Cu,Tu" -i "${CERTIFICATE_PATH}" -d sql:${certdir}
done

echo "Certificate import completed."
