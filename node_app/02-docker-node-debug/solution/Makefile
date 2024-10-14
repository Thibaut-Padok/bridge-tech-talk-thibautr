.PHONY: install start dockerbuild dockerbuild-arm dockerrun ps debug

########################
# 01 - Local debug
########################

# Install node dependencies
install:
	npm install

# Start node server locally
start:
	node index.js

########################
# 02 - Docker debug
########################

# Build the docker image
dockerbuild:
	docker build -t node-app:v0.1.0 .

# For those with arm processor - Help here https://www.padok.fr/en/blog/docker-arm-architectures
dockerbuild-arm:
	docker build --platform "linux/arm64" -t node-app:v0.1.0 .

# Start the app in a docker
dockerrun:
	docker run -d -p 3000:3000 -p 9229:9229 --name node-app node-app:v0.1.0

# Stop and remove docker container
dockerremove:
	docker container stop node-app
	docker container rm node-app
