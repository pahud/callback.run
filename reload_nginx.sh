#!/bin/bash

docker exec -ti callback.run /opt/openresty/nginx/sbin/nginx -s reload
