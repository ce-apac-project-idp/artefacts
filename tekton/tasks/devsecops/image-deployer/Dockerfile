FROM alpine

RUN apk fix && \
    apk --no-cache --update add git git-lfs gpg less openssh patch libc6-compat bash shadow yq && \
    git lfs install

RUN groupadd deployers && useradd -m -d /home/deployer/  deployer && usermod -a -G deployers deployer 
COPY deployment.yaml /tmp
RUN chmod a+w /tmp/deployment.yaml  # Depending on your umask value (default 022 or 002) chmod +w may be different to chmod a+w. So I explicitly pass in the a.
USER deployer 

VOLUME /git
WORKDIR /git

ENTRYPOINT ["tail", "-f", "/dev/null"]
