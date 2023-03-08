#!/bin/bash

## TODO: We are depending on global uniqueness given through the cluster name parameter. Enforce check here

cd /tmp

# Parametrise the name of the configmap and the namespace as enviornment variables passed to the Tekton Job
# This configmap needs to be Git'opsed
# TODO: Fetch this through the passed file from the most upstream task to avoid the overhead of calls
oc get configmap rhacm-aws-install-config-configmap -n scratchspace -o yaml > /tmp/aws-ic-cmap.yaml

# Parameters passed to the Tekton Job via user input in Backstage 
machinePoolName="$CLUSTER_NAME-worker" yq e -i '.metadata.name = env(machinePoolName)' /tmp/machinepool.yaml
yq e -i '.metadata.namespace = env(NAMESPACE)' /tmp/machinepool.yaml
yq e -i '.spec.clusterDeploymentRef.name = env(CLUSTER_NAME)' /tmp/machinepool.yaml
machinePoolName="$CLUSTER_NAME-worker" yq e -i '.spec.name = env(machinePoolName)' /tmp/machinepool.yaml
yq e -i '.spec.platform.aws.region = env(REGION)' /tmp/machinepool.yaml


# Obtain parameter from ConfigMap
type=`yq '.data.compute' aws-ic-cmap.yaml | grep aws.type |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.platform.aws.rootVolume.type = env(type)' /tmp/machinepool.yaml
iops=`yq '.data.compute' aws-ic-cmap.yaml | grep iops |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.platform.aws.rootVolume.iops = env(iops)' /tmp/machinepool.yaml
size=`yq '.data.compute' aws-ic-cmap.yaml | grep size |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.platform.aws.rootVolume.size = env(size)' /tmp/machinepool.yaml
platformType=`yq '.data.compute' aws-ic-cmap.yaml | grep rootVolume.type |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.platform.aws.rootVolume.type = env(platformType)' /tmp/machinepool.yaml
