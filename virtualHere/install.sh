#!/bin/sh

app=$(basename `dirname $0`)

sh -x $(dirname $0)/_install.sh $app