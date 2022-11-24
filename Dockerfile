FROM quay.io/openshift/origin-cli:v3.11.0
WORKDIR ~
CMD ["tail", "-f", "/dev/null"]
