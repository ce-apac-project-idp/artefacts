FROM registry.access.redhat.com/ubi8/ubi-minimal:latest 
RUN curl -o /usr/bin/roxctl  https://mirror.openshift.com/pub/rhacs/assets/3.66.1/bin/Linux/roxctl  && chmod a+x /usr/bin/roxctl  # Use a more later version.
ENTRYPOINT ["tail", "-f", "/dev/null"] # This is just a placeholder, this will be overriden by the script defined in the Task/TaskRun level.
