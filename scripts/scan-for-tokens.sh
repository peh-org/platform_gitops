#!/bin/bash
# scan-for-tokens.sh - Run in CI pipeline

# Check for leaked service account tokens
grep -r "eyJhbGciOi" build.log && { # Base64-encoded beginning of a JWT
  echo "ALERT: Possible token leak detected!"
  exit 1
}

# Check for kubeconfig artifacts
find . -name "*.kubeconfig" -o -name "*config*.yaml" | while read f; do
  grep -q "client-certificate-data" "$f" && {
    echo " Found kubeconfig: $f"
    exit 1
  }
done