# App1

An example application Helm chart that references that "sharedconfig" Helm chart as a dependency (see [Chart.yaml](./Chart.yaml)) then renders it's shared config into it's own unique configmap, and generates a unique shasum for that map on it's deployment Pods.

See it in action:

```sh
helm dependency update && helm template .
```

Then, without changing anything in this repo, update the dependency and see the resulting YAML change the CM and the shasum:

```sh
# make a change
nano ../config/values.yaml

# update the dependency, then re-create the yaml
helm dependency build && helm template .
```

In a GitOps workflow, running a system like this likely requires good dependency management that automatically issues PRs to your repos (in GitHub land, this might be done with [dependabot](https://docs.github.com/en/code-security/supply-chain-security/managing-vulnerabilities-in-your-projects-dependencies/configuring-dependabot-security-updates), though other tools exist).