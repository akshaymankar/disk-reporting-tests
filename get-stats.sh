#!/bin/bash

node_name=${1:-10.72.206.145}

kubectl get --raw "/api/v1/nodes/$node_name/proxy/stats/summary" | \
  jq '(.pods |
        map(select(.podRef.namespace == "default")) |
        map([.podRef.name, .podRef.namespace, ."ephemeral-storage".usedBytes])) |
        ["Name","Namespace","BytesUsed"], ["----","----------","----------"], (.[]) |
        @tsv' -r | \
  column -t
