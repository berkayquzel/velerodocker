FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl wget tar
RUN curl -L https://github.com/heptio/velero/archive/refs/heads/master.tar.gz | tar xvz \
    && cd velero-master \
    && wget https://github.com/vmware-tanzu/velero/releases/download/v1.10.2/velero-v1.10.2-linux-amd64.tar.gz \
    && tar -xvf velero-v1.9.6-linux-amd64.tar.gz \
    && cd velero-v1.5.3-linux-amd64 \
    && mv velero /usr/local/bin \
    && cd /usr/local/bin \
    && echo '[default]' > minio.credentials \
    && echo 'aws_access_key_id=V07OOQGN91M98JNPTD23' >> minio.credentials \
    && echo 'aws_secret_access_key=VL7AzLrTXGMeV9Comwg6dEKYCyXiFjeP' >> minio.credentials \
    && velero install \
        --provider aws \
        --plugins velero/velero-plugin-for-aws:v1.7.0 \
        --use-restic \
        --bucket sandbox-k8s-backups \
        --secret-file ./minio.credentials \
        --backup-location-config region=eu-central-1,s3ForcePathStyle=true,s3Url=https://storage.vkk.io
