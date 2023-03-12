#!/bin/bash

## TODO: We are depending on global uniqueness given through the cluster name parameter. Enforce check here

cd /tmp

# AWS Creds
awsCredsSecretName="$CLUSTER_NAME-aws-creds" yq e -i '.metadata.name = env(awsCredsSecretName)' /tmp/secret-aws-creds.yaml
yq e -i '.metadata.namespace = env(CLUSTER_NAME)' /tmp/secret-aws-creds.yaml
yq e -i '.spec.data[0].secretKey = env(AWS_ACCESS_KEY_NAME)' /tmp/secret-aws-creds.yaml
yq e -i '.spec.data[0].remoteRef.key = env(AWS_ACCESS_KEY_REF)' /tmp/secret-aws-creds.yaml
yq e -i '.spec.data[1].secretKey = env(AWS_SECRET_KEY_NAME)' /tmp/secret-aws-creds.yaml
yq e -i '.spec.data[1].remoteRef.key = env(AWS_SECRET_KEY_REF)' /tmp/secret-aws-creds.yaml
yq e -i '.spec.secretStoreRef.name = env(SECRET_STORE_REF)' /tmp/secret-aws-creds.yaml
targetSecretName="$CLUSTER_NAME-aws-creds" yq e -i '.spec.target.name = env(targetSecretName)' /tmp/secret-aws-creds.yaml


# RedHat Pull Secret
pullSecretName="$CLUSTER_NAME-pull-secret" yq e -i '.metadata.name = env(pullSecretName)' /tmp/secret-pull-secret.yaml
yq e -i '.metadata.namespace = env(CLUSTER_NAME)' /tmp/secret-pull-secret.yaml
yq e -i '.spec.data[0].secretKey = env(OPENSHIFT_PULL_SECRET_KEY_NAME)' /tmp/secret-pull-secret.yaml
yq e -i '.spec.data[0].remoteRef.key = env(OPENSHIFT_PULL_SECRET_KEY_REF)' /tmp/secret-pull-secret.yaml
yq e -i '.spec.secretStoreRef.name = env(SECRET_STORE_REF)' /tmp/secret-pull-secret.yaml
targetSecretName="$CLUSTER_NAME-pull-secret" yq e -i '.spec.target.name = env(targetSecretName)' /tmp/secret-pull-secret.yaml

# SSH Private Key
sshSecretName="$CLUSTER_NAME-ssh-private-key" yq e -i '.metadata.name = env(sshSecretName)' /tmp/secret-ssh-private-key.yaml
yq e -i '.metadata.namespace = env(CLUSTER_NAME)' /tmp/secret-ssh-private-key.yaml
yq e -i '.spec.data[0].secretKey = env(SSH_SECRET_KEY_NAME)' /tmp/secret-ssh-private-key.yaml
yq e -i '.spec.data[0].remoteRef.key = env(SSH_SECRET_KEY_REF)' /tmp/secret-ssh-private-key.yaml
yq e -i '.spec.secretStoreRef.name = env(SECRET_STORE_REF)' /tmp/secret-ssh-private-key.yaml
targetSecretName="$CLUSTER_NAME-ssh-private-key" yq e -i '.spec.target.name = env(targetSecretName)' /tmp/secret-ssh-private-key.yaml
