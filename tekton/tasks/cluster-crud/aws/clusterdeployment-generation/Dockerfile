FROM quay.io/openshift/origin-cli
RUN groupadd builders && useradd builder && usermod -a -G builders builder
RUN yum install -y wget
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
COPY cluster-deployment.yaml /tmp
RUN chmod a+w /tmp/cluster-deployment.yaml  # Depending on your umask value (default 022 or 002) chmod +w may be different to chmod a+w. So I explicitly pass in the a.
USER builder
ENTRYPOINT ["tail", "-f", "/dev/null"] # This is just a placeholder, this will be overriden by the script defined in the Task/TaskRun level.
