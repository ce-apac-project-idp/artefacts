#!/bin/bash

## TODO: We are depending on global uniqueness given through the cluster name parameter. Enforce check here

cd /tmp

# Parametrise the name of the configmap and the namespace as enviornment variables passed to the Tekton Job
# This configmap needs to be Git'opsed
# TODO: Fetch this through the passed file from the most upstream task to avoid the overhead of calls
# ConfigMap not needed here.
# oc get configmap rhacm-aws-install-config-configmap -n scratchspace -o yaml > /tmp/aws-ic-cmap.yaml

# Parameters passed to the Tekton Job via user input in Backstage 
yq e -i '.metadata.name = env(CLUSTER_NAME)' /tmp/namespace.yaml
# Note the quotations. We don't want the nesting in this particular case.
yq e -i '.metadata.annotations."openshift.io/display-name" = env(CLUSTER_NAME)' /tmp/namespace.yaml
yq e -i '.metadata.annotations."cluster.open-cluster-management.io/managedCluster" = env(CLUSTER_NAME)' /tmp/namespace.yaml
yq e -i '.metadata.annotations."kubernetes.io/metadata.name" = env(CLUSTER_NAME)' /tmp/namespace.yaml
