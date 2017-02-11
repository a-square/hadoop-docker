FROM philcryer/min-wheezy:latest
MAINTAINER sgerard <sgerard@emasphere.com>

# prevent apt-get from emitting too many errors and installing too many packages
ENV DEBIAN_FRONTEND noninteractive
ADD 99norecommends /etc/apt/conf.d/

# init wheezy docker
RUN \
	echo 'deb http://ftp.cz.debian.org/debian stable main contrib'>> /etc/apt/sources.list && \
	apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
	cp -R /usr/share/locale/en\@* /tmp/ && \
	rm -rf /usr/share/locale/* && \
	mv /tmp/en\@* /usr/share/locale/ && \
	rm -rf /var/cache/debconf/*-old && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /usr/share/doc/* && \
	apt-get update -yqq && \
	echo "$(cat /etc/issue.net) Docker Image - philcryer/min-wheezy - $(date +'%Y/%m/%d')" > /etc/motd

RUN \
	apt-get install -yqq unzip dnsmasq wget && \
	apt-get clean -yqq && apt-get autoclean -yqq && apt-get autoremove -yqq && \
	rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
	rm -rf /tmp

# dnsmasq configuration
ADD dnsmasq/* /etc/

# install serf
RUN \
	wget -q -o out.log -P /tmp/ --no-check-certificate \
		https://releases.hashicorp.com/serf/0.7.0/serf_0.7.0_linux_amd64.zip && \
    rm out.log && \
	rm -rf /bin/serf && \
	unzip /tmp/serf_0.7.0_linux_amd64.zip -d /bin && \
	rm /tmp/serf_0.7.0_linux_amd64.zip

# configure serf
ENV SERF_CONFIG_DIR /etc/serf
ADD serf/* $SERF_CONFIG_DIR/
ADD handlers $SERF_CONFIG_DIR/handlers
RUN chmod +x $SERF_CONFIG_DIR/event-router.sh $SERF_CONFIG_DIR/start-serf-agent.sh
