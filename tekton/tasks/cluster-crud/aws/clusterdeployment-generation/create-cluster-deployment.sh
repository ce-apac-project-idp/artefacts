#!/bin/bash

## TODO: We are depending on global uniqueness given through the cluster name parameter. Enforce check here

cd /tmp

# Parametrise the name of the configmap and the namespace as enviornment variables passed to the Tekton Job
# This configmap needs to be Git'opsed
oc get configmap rhacm-aws-install-config-configmap -n scratchspace -o yaml > /tmp/aws-ic-cmap.yaml

# Parameters passed to the Tekton Job via user input in Backstage 
yq e -i '.metadata.name = env(CLUSTER_NAME)' /tmp/cluster-deployment.yaml
yq e -i '.metadata.namespace = env(NAMESPACE)' /tmp/cluster-deployment.yaml
yq e -i '.metadata.labels.cloud = env(CLOUD)' /tmp/cluster-deployment.yaml
yq e -i '.metadata.labels.region = env(REGION)' /tmp/cluster-deployment.yaml
yq e -i '.spec.clusterName = env(CLUSTER_NAME)' /tmp/cluster-deployment.yaml
yq e -i '.spec.platform.aws.region = env(REGION)' /tmp/cluster-deployment.yaml

# Obtain parameters from the upstream job
baseDomain=$(echo $BASE_DOMAIN | tr -d ' ')
installConfigRef=$(echo $INSTALL_CONFIG_REF | tr -d ' ')

# Upstream parameters
yq e -i '.spec.baseDomain = env(baseDomain)' /tmp/cluster-deployment.yaml
yq e -i '.spec.provisioning.installConfigSecretRef = env(installConfigRef)' /tmp/cluster-deployment.yaml

# Obtain parameter from ConfigMap - OpenShift Version is provided via a User inpur
version=$(oc get cm  rhacm-aws-install-config-configmap -o yaml | grep "$OS_VERSION=" |  cut -d "=" -f2 | awk '{print $1}') yq e -i '.spec.provisioning.imageSetRef.name = env(version)' /tmp/cluster-deployment.yaml


# TODO: The remaining parameters. These are the references to the SSH, RH Pull and AWS Creds Secrets.