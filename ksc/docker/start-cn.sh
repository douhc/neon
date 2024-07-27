#!/bin/bash
set -eux

SPEC_FILE_ORG=/var/db/postgres/specs/spec.json
SPEC_FILE=/tmp/spec.json

PARAMS=(
     -X PUT
     -H "Content-Type: application/json"
     -d "{\"mode\": \"AttachedSingle\", \"generation\": 1, \"tenant_conf\": {}}"
     "http://pageserver:9898/v1/tenant/${TENANT_ID}/location_config"
)
result=$(curl "${PARAMS[@]}")
echo $result | jq .

PARAMS=(
     -sb 
     -X POST
     -H "Content-Type: application/json"
     -d "{\"new_timeline_id\": \"${TIMELINE_ID}\", \"pg_version\": ${PG_VERSION}}"
     "http://pageserver:9898/v1/tenant/${TENANT_ID}/timeline/"
)
result=$(curl "${PARAMS[@]}")
echo $result | jq .

echo "Overwrite tenant id and timeline id in spec file"
sed "s/TENANT_ID/${TENANT_ID}/" ${SPEC_FILE_ORG} > ${SPEC_FILE}
sed -i "s/TIMELINE_ID/${TIMELINE_ID}/" ${SPEC_FILE}
sed -i "s/SAFEKEEPERS/${SAFEKEEPERS}/" ${SPEC_FILE}
sed -i "s/PAGESERVER_CONNSTRING/${PAGESERVER_CONNSTRING}/" ${SPEC_FILE}

cat ${SPEC_FILE}

echo "Start compute node"
/usr/local/bin/compute_ctl --pgdata /var/db/postgres/compute \
     -C "postgresql://cloud_admin@localhost:55433/postgres"  \
     -b /usr/local/bin/postgres                              \
     -S ${SPEC_FILE}
