FROM debian:jessie

WORKDIR /root

RUN apt-get update \
    && apt-get install -y wget python xz-utils cron git \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-176.0.0-linux-x86_64.tar.gz \
    && tar -zxf google-cloud-sdk-176.0.0-linux-x86_64.tar.gz \
    && ./google-cloud-sdk/install.sh --usage-reporting false \
    && rm google-cloud-sdk-176.0.0-linux-x86_64.tar.gz

RUN wget https://github.com/go-acme/lego/releases/download/v3.0.2/lego_v3.0.2_linux_amd64.tar.gz \
    && tar -xzf lego_v3.0.2_linux_amd64.tar.gz lego \
    && rm lego_v3.0.2_linux_amd64.tar.gz

COPY init.sh /root/init.sh
COPY monthly.sh /root/monthly.sh

COPY crontab /etc/cron.d/letsencrypt

CMD /root/init.sh && cron -f
