#!/bin/bash
set -eux
flux reconcile kustomization platform-services -n flux-system --with-source
# wait 30s for it to settle
for i in $(seq 1 30); do
  S=$(kubectl -n flux-system get kustomizations.kustomize.toolkit.fluxcd.io platform-services -o json \
  | jq -r '.status.conditions[] | select(.type=="Ready") | .status')
    [ "$S" = "True" ] && break || sleep 5
done