FROM debian:jessie

WORKDIR /root

RUN apt-get update \
    && apt-get install -y wget python xz-utils cron \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-176.0.0-linux-x86_64.tar.gz \
    && tar -zxf google-cloud-sdk-176.0.0-linux-x86_64.tar.gz \
    && ./google-cloud-sdk/install.sh --usage-reporting false \
    && rm google-cloud-sdk-176.0.0-linux-x86_64.tar.gz

RUN wget https://github.com/xenolf/lego/releases/download/v0.4.1/lego_linux_amd64.tar.xz \
    && tar -xf lego_linux_amd64.tar.xz lego_linux_amd64 \
    && rm lego_linux_amd64.tar.xz

COPY init.sh /root/init.sh
COPY monthly.sh /root/monthly.sh

COPY crontab /etc/cron.d/letsencrypt

CMD /root/init.sh && cron -f