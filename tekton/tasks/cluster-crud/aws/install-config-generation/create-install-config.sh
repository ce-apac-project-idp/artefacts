#!/bin/bash

## TODO: We are depending on global uniqueness given through the cluster name parameter. Enforce check here

cd /tmp

# Parametrise the name of the configmap and the namespace as enviornment variables passed to the Tekton Job
# This configmap needs to be Git'opsed
oc get configmap rhacm-aws-install-config-configmap -n scratchspace -o yaml > /tmp/aws-ic-cmap.yaml

# Parameters passed to the Tekton Job via user input in Backstage 
yq e -i '.metadata.name = env(CLUSTER_NAME)' /tmp/install-config-template.yaml
yq e -i '.platform.aws.region = env(REGION)' /tmp/install-config-template.yaml

# WORKDIR set to /tmp

# Base Domain
domain=`yq '.data.baseDomain' aws-ic-cmap.yaml` yq e -i '.baseDomain = env(domain)' /tmp/install-config-template.yaml

## ControlPlane 
replicas=`yq '.data.controlPlane' aws-ic-cmap.yaml | grep replicas |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.controlPlane.replicas = env(replicas)' /tmp/install-config-template.yaml
arch=`yq '.data.controlPlane' aws-ic-cmap.yaml | grep architecture |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.controlPlane.architecture = env(arch)' /tmp/install-config-template.yaml
type=`yq '.data.controlPlane' aws-ic-cmap.yaml | grep aws.type |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.controlPlane.platform.aws.type = env(type)' /tmp/install-config-template.yaml
iops=`yq '.data.controlPlane' aws-ic-cmap.yaml | grep iops |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.controlPlane.platform.aws.rootVolume.iops = env(iops)' /tmp/install-config-template.yaml
size=`yq '.data.controlPlane' aws-ic-cmap.yaml | grep size |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.controlPlane.platform.aws.rootVolume.size = env(size)' /tmp/install-config-template.yaml
platformType=`yq '.data.controlPlane' aws-ic-cmap.yaml | grep rootVolume.type |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.controlPlane.platform.aws.rootVolume.type = env(platformType)' /tmp/install-config-template.yaml

## Compute
## Be wary the compute stanza takes in a list, hence the [0]. That said, a replica field can be specified on a per element basis. So it may suffice to just use [0]
replicas=`yq '.data.compute' aws-ic-cmap.yaml | grep replicas |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.compute[0].replicas = env(replicas)' /tmp/install-config-template.yaml
arch=`yq '.data.compute' aws-ic-cmap.yaml | grep architecture |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.compute[0].architecture = env(arch)' /tmp/install-config-template.yaml
type=`yq '.data.compute' aws-ic-cmap.yaml | grep aws.type |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.compute[0].platform.aws.type = env(type)' /tmp/install-config-template.yaml
iops=`yq '.data.compute' aws-ic-cmap.yaml | grep iops |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.compute[0].platform.aws.rootVolume.iops = env(iops)' /tmp/install-config-template.yaml
size=`yq '.data.compute' aws-ic-cmap.yaml | grep size |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.compute[0].platform.aws.rootVolume.size = env(size)' /tmp/install-config-template.yaml
platformType=`yq '.data.compute' aws-ic-cmap.yaml | grep rootVolume.type |  cut -d "=" -f2 | awk '{print $1}'` yq e -i '.compute[0].platform.aws.rootVolume.type = env(platformType)' /tmp/install-config-template.yaml


# We need the public component of the SSH key - This should already be a created secret
pubKey=`oc get secret aws-ssh-secret -n scratchspace -o yaml | yq '.data.ssh-publickey' | base64 -d` yq e -i '.sshKey = env(pubKey)' /tmp/install-config-template.yaml

# Encoded File. Note how the "" were placed around install-config.yaml. This is because the actual field name contains a "." which is rather intuitive. The dot in this case does NOT represent a nested field.
encoded=`cat install-config-template.yaml | base64 -w 0` yq e -i '.data."install-config.yaml" = env(encoded)' /tmp/install-config.yaml 
yq e -i '.metadata.namespace = env(NAMESPACE)' /tmp/install-config.yaml
# https://stackoverflow.com/questions/39568412/creating-ssh-secrets-key-file-in-kubernetes. The secret was created as such.
secretName="$CLUSTER_NAME-install-config" yq e -i '.metadata.name = env(secretName)' /tmp/install-config.yaml

# https://github.com/tektoncd/catalog/blob/main/task/git-clone/0.9/git-clone.yaml
# See the link above in relation to how to save files to shared workspace. line 25, 155, 198 and 228 in particular.

# This can be defined as an env variable in the Tekton task referencing the input workspace.
# cp /tmp/install-config.yaml $WORKSPACE

# We also need to pass some results downstream to the next task, which creates the ClusterDeployment. 
# The CR is a function of aws-creds-ref, pull-secret ref, ssh-secret-ref, install-config-ref, base domain, and the name of the cluster.
# The name of the cluster is given via pipeline inputs. The secrets (besides install-config-ref) should be present as inputs to the pipeline as they are static so we can effectively hardcode them
# The install-config-ref secret and the value associated with the baseDomain will be passed to the downstream task.
# Techincally we don't need to pass the baseDomain as this is present in the configMap but says the overhead of an API call.
# See the bp-task and the pipeline of the devsecops module for more information.
#baseDomain=$(yq '.data.baseDomain' aws-ic-cmap.yaml)
#installConfigRef="$CLUSTER_NAME-install-config"

#echo $baseDomain | tee /tekton/results/baseDomain
#echo $installConfigRef | tee /tekton/results/installConfigRef