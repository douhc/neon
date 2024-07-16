FROM neondatabase/neon:latest

USER root

ENV LANG=en_US.UTF-8 \
        LC_ALL=en_US.UTF-8 \
        TZ=Asia/Shanghai

ENV DEBIAN_FRONTEND=noninteractive

# 修改APT源
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bk
COPY ksc/docker/sources.list /etc/apt/sources.list

RUN apt update  && \
    apt install -y --no-install-recommends  tzdata locales && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    apt install -y --no-install-recommends  procps vim tini lsof grep sed git curl wget telnet ca-certificates gnupg && \
        apt clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/* ~/.cache/*

# USER neon