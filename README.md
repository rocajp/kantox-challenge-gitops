# Kantox Challenge 2
# KubeOps Challenge: Prove Your Kubernetes & GitOps Mastery

# Pre-reqs
## Minikube installation
Requirements:
- kubectl
- docker or podman
- curl
- root permissions

Installation:
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
```
*You can check Minikube version with:*
```
minikube version
```
## Deploy Minukube cluster with ingress
```
minikube start
minikube addons enable ingress
```
*To check cluster info:*
```
kubectl cluster-info
```

# Challenge solution
## Deploy K8s manifests
To deploy the app and service:
```
kubectl apply -f hello-world-k8s/
```
*To check the running POD:*
```
kubectl port-forward svc/hello-world 8080:80
```
*Then visit localhost:8080 in your browser*

## GitHub Actions Workflow
### The GitHub actions WF is in this path: .github/actions/main.yml

The workflow:
- Clone the repository
- Build and push container image to rocajp docker.io registry
- Update tag
- Write semver in DEV manifests of application (ArgoCD automatically update this app in k8s when change succeds, its GitOps flow)

## ArgoCD configuration and GitOps App
Description:
- "charts/" dir have the HELM chart base for applications
- "manifests/" dir have the values files for each environment
- ArgoCD policy is self-heal and auto-prune, the only source of truth is this Git repository

Add HELM repository:
```
helm repo add argo https://argoproj.github.io/argo-helm --force-update
```

Install ArgoCD:
```
helm upgrade --install argocd argo/argo-cd -n argocd --create-namespace -f values.yaml
```

*Get the admin password with:*
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
Login to ArgoCD and add Git chart repository:
```
argocd repo add https://github.com/rocajp/kantox-challenge-gitops --type git
```

Create ArgoCD Projects
```
argocd proj create dev --upsert -d https://kubernetes.default.svc,challenge-dev -s '*' --allow-cluster-resource Namespace
argocd proj create stg --upsert -d https://kubernetes.default.svc,challenge-stg -s '*' --allow-cluster-resource Namespace
argocd proj create prod --upsert -d https://kubernetes.default.svc,challenge-prod -s '*' --allow-cluster-resource Namespace
```

Create ArgoCD hello-world Application in DEV
```
argocd app create hello-world-gitops-dev --project dev --dest-namespace challenge-dev --dest-server https://kubernetes.default.svc --sync-option CreateNamespace=true --sync-policy auto --self-heal --repo https://github.com/rocajp/kantox-challenge-gitops --path manifests/dev/  --upsert --values values.yaml
```

Create ArgoCD hello-world Application in STG
```
argocd app create hello-world-gitops-stg --project stg --dest-namespace challenge-stg --dest-server https://kubernetes.default.svc --sync-option CreateNamespace=true --sync-policy auto --self-heal --repo https://github.com/rocajp/kantox-challenge-gitops --path manifests/stg/  --upsert --values values.yaml
```

Create ArgoCD hello-world Application in PROD
```
argocd app create hello-world-gitops-prod --project prod --dest-namespace challenge-prod --dest-server https://kubernetes.default.svc --sync-option CreateNamespace=true --sync-policy auto --self-heal --repo https://github.com/rocajp/kantox-challenge-gitops --path manifests/prod/  --upsert --values values.yaml
```
`


