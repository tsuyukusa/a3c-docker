CONTAINER=a3c
REGISTRY=
VOLUME='notebooks'
PROCESSOR=gpu
IMAGE=$(REGISTRY)$(CONTAINER)-image:latest-$(PROCESSOR)

build:
	nvidia-docker build --compress --pull -t $(IMAGE) -f Dockerfile.$(PROCESSOR) .
push:
	nvidia-docker push $(IMAGE)
run:
	nvidia-docker run -d \
		-v /etc/localtime:/etc/localtime:ro \
		-v $(VOLUME):/notebooks \
		-p 8888:8888 \
		-p 5901:5901 \
		--log-driver json-file \
		--log-opt max-size=1g \
		--name=$(CONTAINER) \
		--hostname=$(CONTAINER) \
		$(IMAGE)

vol:
	docker volume inspect $(VOLUME) -f '{{.Mountpoint}}'
shell:
	nvidia-docker exec -it $(CONTAINER) /bin/bash
clean: rm
	nvidia-docker rmi $(IMAGE)
rm:
	-nvidia-docker rm -f $(CONTAINER)
rerun: rm run
stop:
	nvidia-docker stop $(CONTAINER)
start:
	nvidia-docker start $(CONTAINER)
restart: stop start
logs:
	nvidia-docker logs -f --tail 1000 $(CONTAINER)
log: logs

