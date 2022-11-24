#!/bin/bash

provider=$(oc get deployment | grep provider-aws  | awk '{print $1;}')

sed -i "s/CHANGEME/$provider/g" /tmp/crb.yaml

echo "Substitution performed"

oc create -f /tmp/crb.yaml

echo "CRB applied"

# The name of the SA is the same as the deployment
oc adm policy add-scc-to-user anyuid -z $provider

echo "Policy applied"

echo "Scaling deployment.."
oc scale deployment $provider --replicas=0
sleep 20
oc scale deployment $provider --replicas=1

# Wait for pod to be up and running (does not imply they are ready)
oc rollout status deployment $provider

while true
do
  num=$(oc get deployment $provider -o=jsonpath='{.status.readyReplicas}')
  if [[ "$num" -eq 1 ]]; then
    echo "Provider deployment is ready"
    break
  else
    echo "Provider deployment not ready. Trying in 30 seconds"
    sleep 30
  fi
done

while true
do
  # The name of the provider revision is the same as the deployment, and by extension the SA
  status=$(oc get providerrevision $provider -o=jsonpath='{.status.conditions[0].status}')
  if [[ "$status" == 'True' ]]; then
    echo "Provider revision is ready"
    break
  else
    echo "Provider revision not yet ready. Trying in 30 seconds"
    sleep 30
  fi
done


