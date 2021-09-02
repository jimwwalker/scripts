#!/bin/bash

# Need brew coreutils for gcsplit
gcsplit -f stats.log_gcsplit stats.log /-u\ \@ns_server/ {*}
# This file not much use
rm stats.log_gcsplit00

# Rename files so they are a bit easier for further steps
for X in $(ls stats.log_gcsplit*)
do
    CMD=$(head -1 $X)
    regex1="cbstats.*11209 (.*)-u"
    regex2="mcstat.*server (.*)"

    if [[ $CMD =~ $regex1 ]]
    then
        v=${BASH_REMATCH[1]}
        suffix=${v// /_}
        mv $X stats.log.$suffix
    elif [[ $CMD =~ $regex2 ]]
    then
        v=${BASH_REMATCH[1]}
        suffix=${v// /_}
        mv $X stats.log.$suffix
    fi
done