FROM quay.io/openshift/origin-cli
RUN groupadd builders && useradd builder && usermod -a -G builders builder
RUN yum install -y wget
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
RUN mkdir /tmp/components
COPY guestbook/ /tmp/components
COPY redis-slave/ /tmp/components
COPY redis-master/ /tmp/components
USER builder
ENTRYPOINT ["tail", "-f", "/dev/null"] # This is just a placeholder, this will be overriden by the script defined in the Task/TaskRun level.
