#!/bin/bash

## TODO: We are depending on global uniqueness given through the cluster name parameter. Enforce check here

cd /tmp

# Parametrise the name of the configmap and the namespace as enviornment variables passed to the Tekton Job
# This configmap needs to be Git'opsed
# TODO: Fetch this through the passed file from the most upstream task to avoid the overhead of calls
oc get configmap rhacm-aws-install-config-configmap -n scratchspace -o yaml > /tmp/aws-ic-cmap.yaml

yq e -i '.metadata.name = env(CLUSTER_NAME)' /tmp/managedclusterinfo.yaml
yq e -i '.metadata.labels.name = env(CLUSTER_NAME)' /tmp/managedclusterinfo.yaml

# Parameters passed to the Tekton Job via user input in Backstage 
yq e -i '.metadata.name = env(CLUSTER_NAME)' /tmp/managedcluster.yaml
yq e -i '.metadata.labels.name = env(CLUSTER_NAME)' /tmp/managedcluster.yaml
yq e -i '.metadata.labels.region = env(REGION)' /tmp/managedcluster.yaml

# ConfigMap Params
cloud=`yq '.data.managedCluster' aws-ic-cmap.yaml | grep cloud |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.metadata.labels.cloud = env(cloud)' /tmp/managedcluster.yaml

# We need to be adding the sync waves as annotations