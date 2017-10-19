Let's Encrypt Google Compute HTTP Load Balancer Docker Updater
===========

Run from a machine already in GCP where the machine itself is authorized to update HTTPS load balancer certificates. This container also requires you use GCP as your DNS provider as it uses GCP-DNS-based Let's Encrypt verification.

    docker run --env GCE_PROJECT=gcp-project-name --env LETSENCRYPT_EMAIL=my@email.com --env TARGET_PROXY=name-of-gcp-target-https-proxy --env DOMAINS_LIST="-d domains.list -d where.each -d is.prefixed.by.a.dash.d" bloomapi/letsencrypt-gcloud-balancer

In production, consider mounting a persistent volume at `/root/.lego` so you don't loose your Let's Encrypt credentials / certs. That said, the scripts currently only work when one certificate / key pair is stored in the container. If you want to change the domains while using persistant storage, make sure you clear the certs and keys out of the `/root/.lego/certificates` directory.

If you are testing, its also worth setting `--env USE_STAGING_SERVER=true` to avoid being rate limited by Let's Encrypt for the month. Keep in mind that since this uses DNS-based verification, it depends on the expiration of DNS TXT records. While this wont matter in production, while testing, you may need to wait 120 seconds between tests.

This container will attempt to renew certificates once a month. The container will also try to have an initial issuing of the certs on first run.

### Required Environment Variables

* `GCE_PROJECT` Your GCP/GCE project
* `LETSENCRYPT_EMAIL` Email to use for Let's Encrypt registration
* `TARGET_PROXY` Name of your GCP https proxy. Find it with `gcloud compute target-https-proxies list` after you've already created a HTTPS load balancer frontent
* `DOMAINS_LIST` A list of domains. Each domain must be prefixed with `-d`. If you want multiple domains, just seperate with a space as demonstrated above.

### Optional Variables

* `USE_STAGING_SERVER` if set, We'll use the Let's Encrypt staging server. This wont issue usable certs, but will allow you to use / reuse the same domains list. *Warning* if you re-create this container more than 5 times in a month without a persistent volume, you will be rate limited and you wont be able to get more certificates until the next month.

Leave the docker container running, and it will attempt to update the cert once a month and remove the older cert once the new cert is installed.
