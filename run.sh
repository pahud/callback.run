#!/bin/bash

pwd=`pwd`
basename=${pwd##*/}
imagename=${basename}

IMAGE_NAME="${imagename}"
CONTAINER_NAME="${IMAGE_NAME}"

# clean up
echo "stop and remove existing container ${CONTAINER_NAME}, please wait..."
docker stop ${CONTAINER_NAME} &>/dev/null; docker rm ${CONTAINER_NAME} &>/dev/null

docker run --name ${CONTAINER_NAME} -p 8080:8080 \
    --restart="always" \
    -v `pwd`:/root/outside \
    -v `pwd`/log/supervisor:/var/log/supervisor \
    -v `pwd`/log/nginx:/opt/openresty/nginx/logs \
    -v `pwd`/lua:/opt/openresty/nginx/conf/lua \
    -v `pwd`/lualib:/opt/openresty/nginx/conf/lualib \
    -v `pwd`/nginx.conf.d/cb.conf:/opt/openresty/nginx/conf/sites-enable.d/cb.conf \
    --env-file=env-file \
    ${extra_addhost} \
    ${link_params} \
    -d ${IMAGE_NAME}

echo "DONE"
