# README

## Notice

Setting spec.web.enabled to True means the following item creates a CR “clients.oidc.security.ibm.com” which is the OIDC provider allowing access to the Web Console. I found this quite finicky in the sense it works sometimes but not the other times. This is likely a bug. I will set this field to False from now on.


## TODO

This is quite bare bones. The template file is hardcoded and there needs to be logic to transform the YAML via the YQ utility given the user inputs.