check-kubeconfig:
	@test $(KUBECONFIG) || (echo "KUBECONFIG override is not set"; exit 1)

cluster:
	k3d cluster get k3s-default || k3d cluster create --port 8500:8500@loadbalancer --k3s-arg "--no-deploy=traefik@server:*" --k3s-arg "--kube-apiserver-arg=feature-gates=ServerSideApply=false@server:*" --wait

sync:
	helmfile sync

start: check-kubeconfig cluster sync

destroy:
	k3d cluster delete

restart: destroy start