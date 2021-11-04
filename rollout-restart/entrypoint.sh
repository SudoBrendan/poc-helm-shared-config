#!/bin/bash

set -e

# config
SERVER="https://kubernetes.default"
CACERT_PATH="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
TOKEN="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
NAMESPACE="$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)"
oc config set-cluster cfc --server="${SERVER}" --certificate-authority="${CACERT_PATH}"
oc config set-context cfc --cluster=cfc
oc config set-credentials sa --token="${TOKEN}"
oc config set-context cfc --user=sa
oc config use-context cfc

 
LIST=$(oc get deployment,deploymentconfig,statefulset,daemonset --selector "${LABEL_KEY}=${LABEL_VALUE}" -o jsonpath='{range .items[*]}{.kind}{"/"}{.metadata.name}{"\n"}{end}')

# apply a patch... (doesn't work with GitOps)
# # shasum prints in format `SHASUM FILENAME` - we only want the SHA
# CONFIGMAP_YAML_SHA_RAW_OUTPUT_ARRAY=( $(oc get configmap/${CONFIGMAP_NAME} -o yaml | shasum -a 256) )
# CONFIGMAP_YAML_SHA=${CONFIGMAP_YAML_SHA_RAW_OUTPUT_ARRAY[0]}
# 
# cat > patch-cm-annotation.yaml <<EOF
# spec:
#   template:
#     metadata:
#       annotations:
#         checksum/config/${CONFIGMAP_NAME}: ${CONFIGMAP_YAML_SHA}
# EOF
# 
# while IFS= read -r resource; do
#     oc patch $resource --patch "$(cat patch-cm-annotation.yaml)"
# done <<< "${LIST}"
# echo "all patches have completed successfully!"

# issue a rollout restart
while IFS= read -r resource; do
    if [[ ! -z "${resource}" ]]; then
        echo "################################################"
        echo "ROLLING OUT ${resource}..."
        echo "################################################"
        oc rollout restart "${resource}"
        sleep 1
        oc rollout status "${resource}"
    fi
done <<< "${LIST}"
echo "all rollouts have completed successfully!"
