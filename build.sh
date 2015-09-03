#!/bin/bash


pwd=`pwd`
basename=${pwd##*/}
imagename=${basename}

IMAGE_NAME="${imagename}"
CONTAINER_NAME="${IMAGE_NAME}"

docker build  -t ${IMAGE_NAME} .

echo "${IMAGE_NAME} built successfully"
