FROM debian:jessie

WORKDIR /root

RUN apt-get update \
    && apt-get install -y wget python xz-utils cron git \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-176.0.0-linux-x86_64.tar.gz \
    && tar -zxf google-cloud-sdk-176.0.0-linux-x86_64.tar.gz \
    && ./google-cloud-sdk/install.sh --usage-reporting false \
    && rm google-cloud-sdk-176.0.0-linux-x86_64.tar.gz

# Temporary fix to build locally including fixes from master
RUN wget https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz && \
    tar xvf go1.7.4.linux-amd64.tar.gz && \
    chown -R root:root ./go && \
    mv go /usr/local
RUN mkdir /root/go
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go

RUN /usr/local/go/bin/go get github.com/xenolf/lego
RUN cd $GOPATH/src/github.com/xenolf/lego && \
    git checkout -b 6bddbfd17a6e1ab782617eeab2f2007c6550b160 && \
    /usr/local/go/bin/go install
RUN cp $GOPATH/bin/lego /root/lego_linux_amd64

# Current release needs fixes from master
#RUN wget https://github.com/xenolf/lego/releases/download/v0.4.1/lego_linux_amd64.tar.xz \
#    && tar -xf lego_linux_amd64.tar.xz lego_linux_amd64 \
#    && rm lego_linux_amd64.tar.xz

COPY init.sh /root/init.sh
COPY monthly.sh /root/monthly.sh

COPY crontab /etc/cron.d/letsencrypt

CMD /root/init.sh && cron -f