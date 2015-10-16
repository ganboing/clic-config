#!/bin/sh

IDEA=$MYCHROOT/opt/idea-IU/bin/idea.sh
export JAVA_HOME=$MYCHROOT/opt/jdk1.7
(cd $MYCHROOT/opt && make idea-IU)
$IDEA $*
