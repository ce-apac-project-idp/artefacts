FROM alpine

RUN apk fix && \
    apk --no-cache --update add git git-lfs gpg less openssh patch libc6-compat bash shadow yq && \
    git lfs install

# Get latest OpenShift CLI
RUN wget --no-check-certificate https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN tar -xzf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN ln -s /openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /bin/oc

VOLUME /git
WORKDIR /git

ENTRYPOINT ["/bin/sleep"]
CMD ["5000"]