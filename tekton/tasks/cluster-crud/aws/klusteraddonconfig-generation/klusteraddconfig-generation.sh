#!/bin/bash

## TODO: We are depending on global uniqueness given through the cluster name parameter. Enforce check here

cd /tmp

# Parametrise the name of the configmap and the namespace as enviornment variables passed to the Tekton Job
# This configmap needs to be Git'opsed
# TODO: Fetch this through the passed file from the most upstream task to avoid the overhead of calls
oc get configmap rhacm-aws-install-config-configmap -n scratchspace -o yaml > /tmp/aws-ic-cmap.yaml

# Parameters passed to the Tekton Job via user input in Backstage 
yq e -i '.metadata.name = env(CLUSTER_NAME)' /tmp/klusteraddonconfig.yaml
yq e -i '.metadata.namespace = env(CLUSTER_NAME)' /tmp/klusteraddonconfig.yaml
yq e -i '.spec.clusterNamespace = env(CLUSTER_NAME)' /tmp/klusteraddonconfig.yaml
yq e -i '.spec.clusterName = env(CLUSTER_NAME)' /tmp/klusteraddonconfig.yaml

# ConfigMap Params
cloud=`yq '.data.klusterlet' aws-ic-cmap.yaml | grep cloud |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.clusterLabels.cloud = env(cloud)' /tmp/klusteraddonconfig.yaml
applicationManager=`yq '.data.klusterlet' aws-ic-cmap.yaml | grep applicationManager |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.applicationManager.enabled = env(applicationManager)' /tmp/klusteraddonconfig.yaml
policyController=`yq '.data.klusterlet' aws-ic-cmap.yaml | grep policyController |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.policyController.enabled = env(policyController)' /tmp/klusteraddonconfig.yaml
searchCollector=`yq '.data.klusterlet' aws-ic-cmap.yaml | grep searchCollector |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.searchCollector.enabled = env(searchCollector)' /tmp/klusteraddonconfig.yaml
iamPolicyController=`yq '.data.klusterlet' aws-ic-cmap.yaml | grep iamPolicyController |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.iamPolicyController.enabled = env(iamPolicyController)' /tmp/klusteraddonconfig.yaml
certPolicyController=`yq '.data.klusterlet' aws-ic-cmap.yaml | grep certPolicyController |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.spec.certPolicyController.enabled = env(certPolicyController)' /tmp/klusteraddonconfig.yaml

# We need to be adding the sync waves as annotations