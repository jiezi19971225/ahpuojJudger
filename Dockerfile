FROM golang
ENV GOPROXY=https://goproxy.cn,direct
COPY ./scheduler /scheduler
WORKDIR /scheduler
RUN go build scheduler.go

FROM gcc
COPY ./scheduler/judgeclient /judgeclient
WORKDIR /judgeclient
RUN g++ judge_client.cc -o judge_client

FROM ubuntu:18.04
LABEL authors="jiezi19971224@gmail.com"
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
    busybox

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

COPY ./assets/judge.conf /home/judge/hustoj_core/etc/judge.conf
COPY ./assets/java0.policy /home/judge/hustoj_core/etc/java0.policy
COPY ./assets/install.sh /home/judge/install.sh
COPY ./scheduler/config.ini /home/judge/scheduler/config.ini

COPY --from=0 /scheduler/scheduler /home/judge/scheduler/scheduler
COPY --from=1 /judgeclient/judge_client /home/judge/scheduler/judge_client

RUN set -ex \
    && chmod a+x /home/judge/install.sh \
    && bash /home/judge/install.sh

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
WORKDIR /home/judge/scheduler/
ENTRYPOINT ["/tini", "--", "./scheduler"]