FROM alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN set -ex \
	&& apk add --no-cache tzdata \
	g++ \
	openjdk11-jdk \
	python3 \
	supervisor \
	go

RUN set -ex \
	&& apk add --no-cache mawk

RUN set -ex \
	&& ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


ENV JAVA_HOME //usr/lib/jvm/java-11-openjdk
ENV PATH $JAVA_HOME/bin:$PATH

WORKDIR /home/judge/

COPY ./assets/docker-entrypoint.sh /usr/local/bin/
COPY ./assets/judge.conf /home/judge/hustoj_core/etc/judge.conf
COPY ./assets/java0.policy /home/judge/hustoj_core/etc/java0.policy
COPY ./assets/install.sh /home/judge/install.sh
COPY ./assets/supervisor_scheduler.conf /etc/supervisor/conf.d/supervisor_scheduler.conf
COPY ./scheduler/config.ini /home/judge/scheduler/config.ini
COPY ./scheduler/scheduler /home/judge/scheduler/scheduler
COPY ./scheduler/judge_client /home/judge/scheduler/judge_client

RUN set -ex \
	&& chmod +x /usr/local/bin/docker-entrypoint.sh \
	&& ln -s /usr/local/bin/docker-entrypoint.sh  /docker-entrypoint.sh

RUN set -ex \
	&& chmod a+x /home/judge/install.sh