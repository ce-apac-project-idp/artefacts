# Crossplane Samples

## Overview

Sample out of the box crossplane managed resources can be found in the "base" directory of the respective cloud provider services. For instance, there exists two base subfolders within the aws directory called mysql and postgres. Each contain a base directory. Thesse directories the managed resources in question (this if of course the corresponding hyperscaler ProviderConfig object is created). You can simply kubectl/oc create these files to spin up the AWS resource in question.

Compositions, CompositeResources/Definitons and claims can be found within the "xr" directory of the respective cloud providder services. For instance, there exists two xr subfolders within the aws directory called mysql and postgres. Each contain the composition, claim and composite resource. They all reference the CompositeResourceDefinition called xrd.yaml.

The sequence is as follows (assuming the Provider and ProviderConfig are stood up):

1) Platform team creates the XRD
2) Platform team creates the Composition
3) Developer/end user creates a claim, which ultimately creates the XR referencing the aformentioned compositon above to manage the "native" CR's provided by the Provider (Ie, those found in the base directory)

Developers/end users only need to create a claim. All the finer details pertaining to the resource itself (as defined in the compositon spec) and the structure of the "query" itself (as defined in the XRD spec" are abstracted away.

## Troubleshooting & Operations

The [docs](https://crossplane.io/docs/v1.10/reference/composition.html#tips-tricks-and-troubleshooting) states the followng:

```
Crossplane relies heavily on status conditions and events for troubleshooting.
```

The pod logs will likely not reveal a whole deal of information to assist with troubleshooting unfortunately. **For the most part, you will have to perform kubectl/oc describe on the following resources**:

1) XRD
2) Claim
3) XR

### Troubleshooting & Operations - Tips

1) Ensure system:serviceaccount:crossplane-system:crossplane (the crossplane SA found in the crossplane namespace) is able to READ/WATCH/LIST/CREATE/PATCH the resource you define/introduce in the XRD file. If you have not done this, you will encounter errors in the crossplane deployment pod stating exactly that when trying to spin up the claim/xr. So ensure this is done after creating the XRD and composition but prior to creating the claim/xr. This lends itself nicely to being Git'Opsed.
2) When you first create the XRD, perform a describe operation. It will complain in the event your custom resource names and/or the api group contains any uppercase characters. Be mindful to lowercase the kind and group field found in the XRD. Do not uppercase them. Refer to the examples provided in the "xr" directory and the xrd file itseld.
3) Creating a claim internally creates the XR which talks to your composition prompting the provider pod to do what is to do to spin up the resources. Describe either the claim/xr should you encounter errors. Unfortunately, some of the error statements are quite cryptic.
4) Delete the claim/xr (whichever you created) once the hyperscaler resource is no longer needed.
5) For some reason, selecting compositions via labels (as seen in the commented out portions in the xr/claim files) does not work. It seems to only work via a direct name reference.
6) Finally, please ensure the spec.compositeTypeRef.apiVersion field in the composition contains the version in addition to the api group. For instance, x.y.z/v1 as opposed to x.y.z.

## References

1) [Managed Resources](https://crossplane.io/docs/v1.10/concepts/managed-resources.html)
2) [CompositeResources](https://crossplane.io/docs/v1.10/concepts/composition.html)
3) [Terminology](https://crossplane.io/docs/v1.10/concepts/terminology.html)

### Next Steps

1) GitOps the role/binding/ for the crossplane serviceaccount as menntioned in the first point in the previous section.
2) Create a SG (manually or through crossplane to allow a custom CIDR range access to the provisioned database) and reference this SG when creating the instances.


