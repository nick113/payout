#!/bin/bash
if tail -n 4 log/processing.log | grep -q true ; then
    echo found
else
    echo not found
fi
