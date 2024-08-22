FROM docker.io/aquasec/tfsec as tfsec
FROM docker.io/tenable/terrascan as terrascan
FROM docker.io/shopify/kubeaudit:v0.11 as kubeaudit
FROM docker.io/bridgecrew/checkov
COPY --from=tfsec /usr/bin/tfsec /usr/local/bin/tfsec
COPY --from=terrascan /go/bin/terrascan /usr/local/bin/terrascan
COPY --from=kubeaudit /kubeaudit /usr/local/bin/kubeaudit
RUN set -ex ; apt-get update ; apt-get install -y less \
    && apt-get clean && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]