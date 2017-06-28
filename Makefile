PROCESSOR=gpu
VOLUME='notebooks'
CONTAINER=a3c
REGISTRY=
IMAGE=$(REGISTRY)$(CONTAINER)-image:latest-$(PROCESSOR)

ifeq ($(PROCESSOR), gpu)
	COMMAND=nvidia-docker
else ($(PROCESSOR), cpu)
	COMMAND=docker
endif

build:
	$(COMMAND) build --compress --pull -t $(IMAGE) -f Dockerfile.$(PROCESSOR) .
push:
	$(COMMAND) push $(IMAGE)
run:
	$(COMMAND) run -d \
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
	$(COMMAND) volume inspect $(VOLUME) -f '{{.Mountpoint}}'
shell:
	$(COMMAND) exec -it $(CONTAINER) /bin/bash
clean: rm
	$(COMMAND) rmi $(IMAGE)
rm:
	$(COMMAND) rm -f $(CONTAINER)
rerun: rm run
stop:
	$(COMMAND) stop $(CONTAINER)
start:
	$(COMMAND) start $(CONTAINER)
restart: stop start
logs:
	$(COMMAND) logs -f --tail 1000 $(CONTAINER)
log: logs

