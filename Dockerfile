FROM pahud/openresty

MAINTAINER Pahud "pahudnet@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade

ADD ./nginx.conf.d/nginx.conf /opt/openresty/nginx/conf/nginx.conf
ADD ./nginx.conf.d/cb.conf /opt/openresty/nginx/conf/sites-enable.d/

