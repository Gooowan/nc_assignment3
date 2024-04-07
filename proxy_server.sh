#!/bin/bash

FIRST_VALUE=$((SOCAT_PPID - 5))

SECOND_VALUE=$(awk '{print $1}' /proc/uptime | cut -d '.' -f 1)

RESULT=$(( (FIRST_VALUE + SECOND_VALUE) % 2 ))

if [ $RESULT -eq 1 ]; then
    curl http://localhost:20000/index.html
else
    curl http://localhost:20000/error.html
fi
