#!/bin/bash

function traverse() {
    echo "Traverse 1=${1} 2=${2}"
    if [[ -d ${1}/.repo ]]; then
        proj=$(basename ${2})
        echo "Building ${2}"
        #cd "${1}/build/" && ninja ${proj}_everything
        #cd "${1}/build/" && ninja ${proj}/engines/ep/CMakeFiles/ep_objs.dir/src/item.cc.o
        #cd "${1}/build/" && ninja ${proj}/engines/ep/CMakeFiles/ep_objs.dir/src/warmup.cc.o

        #cd "${1}/build/" && ninja ${proj}/memcached_unsigned_leb128_bench
        #cd "${1}/build/" && ninja ${proj}/memcached_unsigned_leb128_test
        cd "${1}/build/" && ninja ${proj}/ep-engine_ep_unit_tests
    else
        echo "      No .repo 1=${1} 2=${2}"
        traverse $(dirname $1) $1
    fi
}

function main() {
    echo "Starting build from file $1"
    traverse "$1" "$1"
}

main "$1"
