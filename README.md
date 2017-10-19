Let's Encrypt Google Compute HTTP Load Balancer Docker Updater
===========

Run from a machine already in GCP.

    docker run bloomapi/letsencrypt-gcloud-balancer --env GCE_PROJECT=gcp-project-name --env LETSENCRYPT_EMAIL=my@email.com --env TARGET_PROXY=name-of-gcp-target-https-proxy --env DOMAINS_LIST="-d domains.list -d where.each -d is.prefixed.by.a.dash.d"

If you are testing, its also worth setting `--env USE_STAGING_SERVER=true` to avoid being rate limited by Let's Encrypt for the month.

### Required Environment Variables

* `GCE_PROJECT` Your GCP/GCE project
* `LETSENCRYPT_EMAIL` Email to use for Let's Encrypt registration
* `TARGET_PROXY` Name of your GCP https proxy. Find it with `gcloud compute target-https-proxies list` after you've already created a HTTPS load balancer frontent
* `DOMAINS_LIST` A list of domains. Each domain must be prefixed with `-d`. If you want multiple domains, just seperate with a space as demonstrated above.

### Optional Variables

* `USE_STAGING_SERVER` if set, We'll use the Let's Encrypt staging server. This wont issue usable certs, but will allow you to use / reuse the same domains list. *Warning* if you re-create this container more than 5 times in a month without a persistent volume, you will be rate limited and you wont be able to get more certificates until the next month.

Leave the docker container running, and it will attempt to update the cert once a month and remove the older cert once the new cert is installed.
