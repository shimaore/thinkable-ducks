#
# This is a generic Makefile. It uses contents from package.json
# to build Docker images.
#
NAME=shimaore/`jq -r .name package.json`
TAG=`jq -r .version package.json`
SUPERVISOR_PORT=`jq -r .supervisor_port package.json`

image: supervisord.conf
	npm install
	docker build -t ${NAME}:${TAG} .
	docker tag -f ${NAME}:${TAG} ${REGISTRY}/${NAME}:${TAG}

%: %.src
	sed -e "s/SUPERVISOR_PORT/${SUPERVISOR_PORT}/" $< >$@

tests:
	npm test

push: image tests
	docker push ${REGISTRY}/${NAME}:${TAG}
	docker push ${NAME}:${TAG}
	docker rmi ${REGISTRY}/${NAME}:${TAG}
	docker rmi ${NAME}:${TAG}
