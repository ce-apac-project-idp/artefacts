#!/bin/bash




while true
do
  num=$(oc get deployment provider-aws-245ce7fb587d -o=jsonpath='{.status.readyReplicas}')
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
  status=$(oc get providerrevision provider-aws-245ce7fb587d -o=jsonpath='{.status.conditions[0].status}')
  if [[ "$status" == 'True' ]]; then
    echo "Provider revision is ready"
    break
  else
    echo "Provider revision not yet ready. Trying in 30 seconds"
    sleep 30
  fi
done


