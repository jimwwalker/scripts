#!/bin/python3

import sys

# Using vbucket-details from previous split_stats
files = sys.argv[1:]

active={}
replicas={}

for file in files:
    f = open(file, "r")
    mode=None
    currentVB=None
    for line in f.readlines():
        if " vb_" not in line:
            continue
        if ":topology" in line:
            # Skip this line as it could contain active or replica and mess up
            # this noddy parse
            continue
        data = line.split(":")

        if "active" in line:
            mode=1
            currentVB=data[0].strip()
            if currentVB in active:
                print("{} already tracked?".format(currentVB))
                sys.exit(1)
            continue
        if "replica" in line:
            mode=2
            currentVB=data[0].strip()

            # Is this replica already tracked?
            if currentVB in replicas:
                # Yes
                replicas[currentVB]['idx'] = replicas[currentVB]['idx'] + 1
                replicas[currentVB]['data'].append({"node_name":file})
            continue

        if mode == 1:
            if currentVB not in active:
                active[currentVB] = {"node_name":file}
            active[currentVB][data[1]] = data[2].strip()
        elif mode == 2:
            if currentVB not in replicas:
                replicas[currentVB] = {}
                replicas[currentVB]['idx'] = 0
                replicas[currentVB]['data'] = []
                # Append an empty dictionary
                replicas[currentVB]['data'].append({"node_name":file})

            idx=replicas[currentVB]['idx']

            replicas[currentVB]['data'][idx][data[1]] = data[2].strip()

        else:
            print("HMM {}".format(line))
            sys.exit(1)
    f.close()

for vb in active:
    data = active[vb]

    if vb not in replicas:
        print("WARNING: Cannot find {} in replicas".format(vb))
        continue

    replica = replicas[vb]['data']

    for vbR in replica:
        if data['num_items'] != vbR['num_items']:
            # replication lag?
            print("WARNING: {} num_items differ a:{} vs r:{} a:{}, r:{}".format(vb, data['num_items'], vbR['num_items'], data['node_name'], vbR['node_name']))



