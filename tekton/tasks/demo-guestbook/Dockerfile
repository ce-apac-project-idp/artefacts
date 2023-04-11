FROM alpine
RUN addgroup -S builders && adduser -S builder -G builders
RUN apk fix && \
    apk --no-cache --update add git git-lfs gpg less openssh patch libc6-compat bash shadow yq && \
    git lfs install
COPY redis-component.yaml /tmp
COPY app-component.yaml /tmp
RUN chmod a+w /tmp/redis-component.yaml  # Depending on your umask value (default 022 or 002) chmod +w may be different to chmod a+w. So I explicitly pass in the a.
RUN chmod a+x /tmp/app-component.yaml
USER builder
ENTRYPOINT ["tail", "-f", "/dev/null"] # This is just a placeholder, this will be overriden by the script defined in the Task/TaskRun level.
