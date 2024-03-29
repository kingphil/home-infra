.DEFAULT_GOAL := apps

.PHONY: source
source:
	flux reconcile source git flux-system

.PHONY: infrastructure
infrastructure:
	flux reconcile kustomization infrastructure --with-source

.PHONY: apps
apps:
	flux reconcile kustomization apps --with-source

.PHONY: suspend
suspend:
	flux suspend source git flux-system

.PHONY: resume
resume:
	flux resume source git flux-system

.PHONY: k3d-cluster-create
k3d-cluster-create:
	KUBECONFIG=$$HOME/.kube/k3d k3d cluster create development --config misc/development/k3d/k3d.yaml
	kubectl --kubeconfig $$HOME/.kube/k3d create -f ./misc/development/k3d/calico.yaml

.PHONY: k3d-cluster-delete
k3d-cluster-delete:
	KUBECONFIG=$$HOME/.kube/k3d k3d cluster delete development
	rm -f $$HOME/.kube/k3d

.PHONY: kind-create-cluster
kind-create-cluster:
	kind create cluster --name development --kubeconfig $$HOME/.kube/kind --config misc/development/kind/kind.yaml
	#kubectl --kubeconfig $$HOME/.kube/kind create -f ./misc/development/kind/calico.yaml

.PHONY: kind-create-cluster-bleed
kind-create-cluster-bleed:
	# https://hub.docker.com/r/kindest/node/tags
	kind create cluster --name development --kubeconfig $$HOME/.kube/kind --config misc/development/kind/kind.yaml --image kindest/node:v1.29.2

.PHONY: kind-delete-cluster
kind-delete-cluster:
	KUBECONFIG=$$HOME/.kube/kind kind delete cluster --name development
	rm -f $$HOME/.kube/kind
