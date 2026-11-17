#!/bin/bash
# Quick security audit for Maria's team

echo "Cluster Security Inventory"

# Find overly permissive RoleBindings
kubectl get clusterrolebindings -o json | jq -r '
  .items[] |
  select(.roleRef.name=="cluster-admin") |
  .metadata.name + ": " + (.subjects[].name // "unknown")'

# Identify service accounts with secrets
kubectl get serviceaccounts -A -o json | jq -r '
  .items[] |
  select(.secrets|length> 0) |
  .metadata.namespace + "/" + .metadata.name'

# Check for pods running as root
kubectl get pods -A -o json | jq -r '
  .items[] |
  select(.spec.securityContext.runAsUser == 0) |
  .metadata.namespace + "/" + .metadata.name + " (ROOT!)"'