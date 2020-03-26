#!/usr/bin/env bash
set -x
set -e

for f in ${1}/install/kubernetes/operator/charts/istio-telemetry/grafana/dashboards/*; do
  name=$(basename -- ${f} | sed 's/.json/.yaml/g')
  basename=$(echo $name | cut -f1 -d .)
  cat > ./packages/istio/templates/dashboards/$name << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: $basename
  labels:
    grafana_dashboard: "1"
data:
  ${basename}.json: |-
$(cat ${f} | sed 's/^/    /g')
EOF
done


