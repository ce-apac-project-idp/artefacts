FROM alpine

RUN apk fix && \
    apk --no-cache --update add git git-lfs gpg less openssh patch libc6-compat bash shadow yq && \
    git lfs install

#ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
#ENV GLIBC_VERSION=2.30-r0

#RUN set -ex && \
#    apk --update add libstdc++ curl ca-certificates && \
#    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
#        do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
#    apk add --allow-untrusted /tmp/*.apk && \
#    rm -v /tmp/*.apk && \
#    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

# Get latest OpenShift CLI
RUN wget --no-check-certificate https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN tar -xzf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
RUN ln -s /openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /bin/oc

VOLUME /git
WORKDIR /git

#RUN pam-auth-update
#RUN chsh -s /bin/bash

ENTRYPOINT ["/bin/sleep"]
CMD ["5000"]