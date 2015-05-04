#
# This is a generic Makefile. It uses contents from package.json
# to build Docker images.
#
NAME=shimaore/`jq -r .name package.json`
TAG=`jq -r .version package.json`

image:
	npm install
	docker build --rm=true -t ${NAME}:${TAG} .
	docker tag ${NAME}:${TAG} ${NAME}:latest
	docker tag ${NAME}:${TAG} ${REGISTRY}/${NAME}:${TAG}
	docker tag ${NAME}:${TAG} ${REGISTRY}/${NAME}

image-no-cache:
	docker build --rm=true --no-cache -t ${NAME}:${TAG} .
	docker tag ${NAME}:${TAG} ${NAME}:latest

tests:
	npm test

push: image tests
	# docker push ${NAME}:${TAG}
	# docker push ${NAME}:latest
	docker push ${REGISTRY}/${NAME}:${TAG}
	docker push ${REGISTRY}/${NAME}
