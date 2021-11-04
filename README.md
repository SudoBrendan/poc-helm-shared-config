# Helm SharedConfig POC

This repo is a proof of concept on how to use [Helm Hooks](https://helm.sh/docs/topics/charts_hooks/) to have a shared ConfigMap between many microservices and re-issue `oc rollout restart` commands for all resources that use the config.

## Demo

![shared config demo GIF](./images/helm-shared-config-demo.gif)

This demo showcases a Namespace with 4 microservices. 1, 2, and 3 are labelled with `sharedconfig=democonfig-sharedconfig`, 4 is not. When we issue `helm install democonfig .`, we create a ConfigMap `democonfig-sharedconfig` and additionally, spin up a Pod to iterate through all resources labelled with `sharedconfig=democonfig-sharedconfig` and issue a `oc rollout restart`. Support also exists for `helm upgrade` and `helm rollback`.