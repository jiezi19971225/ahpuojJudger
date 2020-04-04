FROM ubuntu:18.04

COPY ./assets/sources.list /etc/apt/sources.list

RUN set -ex \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& chmod -R 777 /tmp \
	&& mv /var/lib/apt/lists /tmp \
	&& mkdir -p /var/lib/apt/lists/partial \
	&& apt-get clean \
	&& apt-get update \
	&& apt-get install -y tzdata

RUN set -ex \
	&& apt-get install -y \
	g++\
	openjdk-8-jdk \
	nano \
	python3.7 \
	nodejs \
	wget \
	busybox \
	supervisor

RUN set -ex \
	&& apt-get clean \
	&& ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& dpkg-reconfigure -f noninteractive tzdata

RUN set -ex \
	&& wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz \
	&&  tar -xvf go1.13.1.linux-amd64.tar.gz \
	&& mv go /usr/lib/go \
	&& rm go1.13.1.linux-amd64.tar.gz

WORKDIR /home/judge/

COPY ./assets/docker-entrypoint.sh /usr/local/bin/
COPY ./assets/judge.conf /home/judge/hustoj_core/etc/judge.conf
COPY ./assets/java0.policy /home/judge/hustoj_core/etc/java0.policy
COPY ./assets/install.sh /home/judge/install.sh
COPY ./assets/supervisor_scheduler.conf /etc/supervisor/conf.d/supervisor_scheduler.conf
COPY ./scheduler/scheduler /home/judge/scheduler/scheduler
COPY ./scheduler/judge_client /home/judge/scheduler/judge_client
COPY ./scheduler/config.ini /home/judge/scheduler/config.ini

RUN set -ex \
	&& chmod +x /usr/local/bin/docker-entrypoint.sh \
	&& ln -s /usr/local/bin/docker-entrypoint.sh  /docker-entrypoint.sh

RUN set -ex \
	&& chmod a+x /home/judge/install.sh \
	&& bash /home/judge/install.sh