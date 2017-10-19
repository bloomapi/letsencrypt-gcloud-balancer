Let's Encrypt Google Compute HTTP Load Balancer Docker Updater
===========

Run from a machine already in GCP.

    docker run bloomapi/letsencrypt-gcloud-balancer --env GCE_PROJECT=gcp-project-name --env LETSENCRYPT_EMAIL=my@email.com --env TARGET_PROXY=name-of-gcp-target-https-proxy --env DOMAINS_LIST="-d domains.list -d where.each -d is.prefixed.by.a.dash.d"

If you are testing, its also worth setting `--env USE_STAGING_SERVER=true` to avoid being rate limited by Let's Encrypt for the month.

Leave the docker container running, and it will attempt to update the cert once a month and remove the older cert once the new cert is installed.