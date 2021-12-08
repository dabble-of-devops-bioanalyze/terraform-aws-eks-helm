terraform/shell:
	docker run --rm -it \
		-v $(shell pwd)/../.aws:/root/.aws \
		-v $(shell pwd)/../.kube:/root/.kube \
		-v $(shell pwd)/../:/root/project \
		-v $(shell pwd)/../../../terraform-recipes:/root/terraform-recipes \
		-w /root/project/examples/nginx \
		dabbleofdevops/terraform:terraform-0.14.0 bash

