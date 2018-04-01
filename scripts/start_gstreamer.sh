#!/bin/bash

cd $HOME
# Determine if the param file exists.  If not, use default.
if [ -e gstreamer.param ]; then
    paramFile="gstreamer.param"
else
    paramFile="companion/params/gstreamer.param.default"
fi

xargs -a $paramFile gst-launch-1.0
