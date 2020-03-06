#!/bin/bash
~/cloud_sql_proxy -instances=$CLOUDSQL_CONNECTION_NAME=tcp:5432 &
sleep 5
go test