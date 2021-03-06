#!/usr/bin/env bash

# Usage: die [exit_code] [error message]
die() {
  local code=$? now=$(date +%T.%N)
  if [ "$1" -ge 0 ] 2>/dev/null; then  # assume $1 is an error code if numeric
    code="$1"
    shift
  fi
  echo "$0: ERROR at ${now%???}${1:+: $*}" >&2
  exit $code
}

count=0
wallets=(alice_1 alice_2 alice_3 bob_1 bob_2 bob_3 carol_1 carol_2 carol_3 dave_1 dave_2 dave_3 eve_1 eve_2 eve_3 mallory_1 mallory_2 mallory_3)

# Check if it exists as a node module or not
walletsPath=$(cat ../../wallets.json | grep -q 'alice' && echo "../../wallets.json" || echo "./wallets.json")

# Returns all wif without null values
cat ${walletsPath} | jq -r '.[][] | (.wif // empty)' |
# Iterate
while read -r wif
do
    bitcoin-cli importprivkey ${wif} ${wallets[count]} || die
    ((count ++))
done
