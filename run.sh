#!/bin/bash
cd "$(dirname "$0")"
echo "Compiling FlightServer..."
javac -cp "mysql-connector-j-26.7.0.jar" FlightServer.java
if [ $? -ne 0 ]; then
  echo "Compile failed"
  exit 1
fi
echo "Starting Cloud Node Flight Booking on http://localhost:8080 ..."
java -cp ".:mysql-connector-j-26.7.0.jar" FlightServer "$@"
