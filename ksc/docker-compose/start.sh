#!/bin/bash

PG_VERSION=16  docker-compose --profile compute -f docker-compose.yml up --build -d
PG_VERSION=16  docker-compose --profile compute -f docker-compose.yml logs
# PG_VERSION=16  docker-compose scale compute=0
# psql -h localhost -U cloud_admin -p 55433 -d postgres