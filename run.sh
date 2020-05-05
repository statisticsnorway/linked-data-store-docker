#!/usr/bin/env sh

if [ "$JAVA_MODULE_SYSTEM_ENABLED" == "true" ]; then
  echo "Starting java using MODULE-SYSTEM"
  export JPMS_SWITCHES=""
  exec java $JPMS_SWITCHES -p /lds/lib -m no.ssb.lds.server/no.ssb.lds.server.Server
else
  echo "Starting java using CLASSPATH"
  exec java -cp "/lds/lib/*" no.ssb.lds.server.Server
fi
