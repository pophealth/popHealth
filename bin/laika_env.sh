#!/bin/sh
# This script sets the CLASSPATH environment variable to include the Saxon jars
FULL_SCRIPT_PATH="$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"
PATH_ONLY=`dirname "$FULL_SCRIPT_PATH"`

CLASSPATH=$PATH_ONLY/lib/saxon/saxon9.jar:$PATH_ONLY/lib/saxon/saxon9-dom.jar

export CLASSPATH