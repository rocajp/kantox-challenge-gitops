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
