#!/bin/bash

function build() {
    echo ${1}
    ninja ${1}
    #PPATH="/Users/jimwalker/Code/couchbase/couchstore.buildlog/python/"
    #LIBRARY_PATH="/Users/jimwalker/Code/couchbase/couchstore.buildlog/"
    #BUILD_LOG_COUCHSTORE="/Users/jimwalker/Code/couchbase/couchstore.buildlog/buildlog.couch"
    #~/scripts/ninjatracing/ninjatracing .ninja_log | jq . | DYLD_LIBRARY_PATH=${LIBRARY_PATH} PYTHONPATH=${PPATH} /usr/local/bin/python3 /Users/jimwalker/Code/couchbase/couchstore.buildlog/python/jww_update_build.py ${BUILD_LOG_COUCHSTORE}
}

function traverse() {
    echo "Traverse 1=${1} 2=${2}"
    if [[ -d ${1}/.repo ]]; then
        proj=$(basename ${2})
        echo "Building ${2}"
        cd "${1}/build/"

        #build ${proj}/all
        #build kv_engine/engines/ep/tests/CMakeFiles/ep-engine_ep_unit_tests.dir/module_tests/range_scan_test.cc.o
        build ${proj}_everything
        #build kv_engine/ep-engine_ep_unit_tests
        #build ${proj}_everything
        #build ${proj}/xattr_test
        #build  kv_engine/engines/ep/CMakeFiles/ep_objs.dir/Unity/unity_16_cxx.cxx.o

        #cd "${1}/build/" && ninja ${proj}/memcached_testapp
        #cd "${1}/build/" && ninja ${proj}_everything
        #cd "${1}/build/" && ninja ${proj}/engines/ep/CMakeFiles/ep_objs.dir/src/item.cc.o
        #cd "${1}/build/" && ninja ${proj}/engines/ep/CMakeFiles/ep_objs.dir/src/dcp/consumer.cc.o
        #cd "${1}/build/" && ninja ${proj}/all
    else
        echo "      No .repo 1=${1} 2=${2}"
        traverse $(dirname $1) $1
    fi
}

function main() {
    if [ -z "$1" ]
    then
        echo "Failing for empty input"
        exit 1
    fi
    echo "Starting build from file $1"
    traverse "$1" "$1"
}

main "$1"
