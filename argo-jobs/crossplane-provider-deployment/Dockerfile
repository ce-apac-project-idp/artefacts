FROM quay.io/openshift/origin-cli:v3.11.0
WORKDIR ~
COPY crb.yaml /tmp/crb.yaml
COPY configure-deployment.sh configure-deployment.sh
RUN chmod a+x configure-deployment.sh
CMD ["./configure-deployment.sh"]
