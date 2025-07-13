#!/bin/bash

if [ -z $JAVA_HOME ]; then
    JAVA_HOME=/usr/lib/jvm/liberica-jdk-17-full
fi

/opt/autopsy/bin/autopsy --jdkhome $JAVA_HOME
