#!/bin/bash
set -eux

# flux reconcile test
# flux reconcile kustomization platform-services -n flux-system --with-source
# # wait 30s for it to settle
# for i in $(seq 1 30); do
#   S=$(kubectl -n flux-system get kustomizations.kustomize.toolkit.fluxcd.io platform-services -o json \
#   | jq -r '.status.conditions[] | select(.type=="Ready") | .status')
#     [ "$S" = "True" ] && break || sleep 5
# done

# istio http-gateway test
kubectl -n istio-system apply -f smoke/http-gateway.yaml

# Wait for job completion (120s); print logs on failure
kubectl -n istio-system wait --for=condition=complete \
      job/smoke-gateway --timeout=120s || \
      (kubectl -n istio-system logs job/smoke-gateway; exit 1)
# Remove configuration once complete
kubectl -n istio-system delete -f smoke/http-gateway.yaml