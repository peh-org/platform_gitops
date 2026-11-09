# platform_gitops (App of Apps)

## About
- The 'App of Apps'
- GitOps type of application deployment
    - Build out application and test as needed. When ready, add to `/environments/<env>/tenants/<repo-name>` and Flux will manage cluster from there
- Utilize Flux to track all repos (platform_services, etc.)
- Flux and Kustomize will update cluster based on guest repo configs. Only update specific repos, not entire cluster
- Central location for cluster management

## Open Policy Administration (OPA & Rego)
- Utilize OPA via `policy/flux.rego`
    - can be integrated into circleci pipeline or managed inside of cluster via Gatekeeper Helm release

## How Flux works
- Monitor org repos (/<repo_name>/environments/sandbox) and deploy based on manifests inside of those repos
    - `platform-gitops` - /environments/<env>/tenants/<repo-name>/<repo-name>.yaml
        - `/environments/sandbox/tenants/platform-services/platform-services.yaml`
            - tracks which git repo to watch. used in updating cluster
            - tracks which folder to Kustomize inside of the guest repo
    - `platform-services`
        - `/environments/sandbox/kustomization.yaml`
            - manage kustomization base and env-specific cluster resources