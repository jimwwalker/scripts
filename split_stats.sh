#!/bin/bash

# first run split_stats.sh
# e.g. for each cbcollect cd cbcollect; ./split_stats.sh; cd -
# Next run split_stats_to_buckets (for the stat of interest)
# e.g. for X in $(ls cbcollect*); do cd $X; ~/scripts/split_stats_to_buckets.sh stats.log.vbucket-details_ ; cd -; done
# Now run compare_vbucket_details.py (pass each file from above step as a param)

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