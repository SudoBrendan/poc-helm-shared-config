# Rollout Restart

A container that uses integrated kubernetes auth to iterate through resources based on a given label key/value pair, then issue `oc rollout restart` on each resource discovered. Used by the [sharedconfig Helm chart](../sharedconfig).
