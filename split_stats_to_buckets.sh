#!/bin/bash

# Need brew coreutils for gcsplit
gcsplit -f $1.gcsplit $1 "/^\*\*\*\*/" {*}
rm $1.gcsplit00

# Rename files so they are a bit easier for further steps
for X in $(ls $1.gcsplit*)
do
    BUCKET=$(sed -n '2p' $X)
    suffix=${BUCKET// /_}
    mv $X $1.$suffix
done