FROM hashicorp/terraform:latest

RUN \
  apk update && \
  apk add bash py-pip git && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev make && \
  pip install azure-cli && \
  apk del --purge build && \
  az aks install-cli
