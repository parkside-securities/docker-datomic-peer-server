#!/usr/bin/env bash
set -e

if [[ $# -eq 0 ]]; then
    printf "usage: $(basename $0) <version> \n";
    exit 1;
fi

sed -i '' -e "s/^ENV DATOMIC_VERSION [0-9]\.[0-9]\.[0-9]*/ENV DATOMIC_VERSION $1/" Dockerfile
sed -i '' -e "s/datomic-peer-server:[0-9]\.[0-9]\.[0-9]*/datomic-peer-server:$1/" README.md
