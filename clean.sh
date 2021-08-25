#!/bin/bash
#
 ps -ef | grep tctconfig.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
