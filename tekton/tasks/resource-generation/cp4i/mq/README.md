# README

## Notice

Setting spec.web.enabled to True means the following item creates a CR “clients.oidc.security.ibm.com” which is the OIDC provider allowing access to the Web Console. I found this quite finicky in the sense it works sometimes but not the other times. This is likely a bug. I will set this field to False from now on.


## TODO

This is quite bare bones. The template file is hardcoded and there needs to be logic to transform the YAML via the YQ utility given the user inputs.

Right now, the MQ creation is relatively simple. The corresponding docker image in the artefacts repo uses a hardcoded YAML for the QM and MQSC configmap. I should be taking the user input and parsing said input using sed/yq and changing the QueueManager and ConfigMap YAML's, but this is not being done at the moment. This is a future action.

As a consequence of this, the Queue Manager, Queue, Channel and Sec Objects are hardcoded. Which means we need to hardcode these the values associated with said resources within the ACE app. Again, these ought to be decoupled as Configuration Objects in the future re ACE flow.
