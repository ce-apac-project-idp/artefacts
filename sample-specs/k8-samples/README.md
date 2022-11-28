# K8 Samples

## Sleeper

The sleeper folder contains a podspec.yaml (Don't worry about the other pod.yaml) file which spins up a sample image I created. This sample image has elevated privileges as it references an elevated service account.

Perform commands within this image to help you when writing shell scripts for the job. Execute each command in succession and append to your final script.

## Nginx

This folder contains a deployment of nginx containers. The pods never spin up as nginx uses a privileged port by default. And OpenShift does not allow this by default. Test this deployment if you needed to perform rollout/scale/patch commands. Best used in conjunction with the sleeper pod mentioned above.