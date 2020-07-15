#!/bin/bash
# DO NOT RUN THIS SCRIPT, USE SCRIPTS UNDER VERSIONS DIRECTORIES

set -exuo pipefail

CI=${CI:-"false"}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
provision_dir="$1"

function cleanup {
  cd "$DIR" && cd ../..
  make cluster-down
}

# repetition cluster-up
(
  ksh="./cluster-up/kubectl.sh"
  cd "$DIR" && cd ../..
  export KUBEVIRTCI_PROVISION_CHECK=1
  export KUBEVIRT_PROVIDER="k8s-${provision_dir}"
  export KUBEVIRT_NUM_NODES=2
  export KUBEVIRT_NUM_SECONDARY_NICS=2
  export KUBEVIRT_WITH_CNAO=true
  trap cleanup EXIT ERR SIGINT SIGTERM SIGQUIT
  bash -x ./cluster-up/up.sh
  ${ksh} wait --for=condition=Ready pod --timeout=200s --all
  ${ksh} wait --for=condition=Ready pod --timeout=200s -n kube-system --all
  ${ksh} get nodes
  ${ksh} get pods -A

  pre_pull_image_file="$DIR/${provision_dir}/extra-pre-pull-images"
  if [ -f "${pre_pull_image_file}" ]; then
    bash -x "$DIR/deploy-manifests.sh" "${provision_dir}"
    bash -x "$DIR/check-pod-images.sh" "${provision_dir}"
    bash -x "$DIR/validate-pod-pull-policies.sh"
  fi

  # Run conformance test only at CI and if the provider has them activated
  conformance_config=$DIR/${provision_dir}/conformance.json
  if [ "${CI}" == "true" -a -f $conformance_config ]; then
    hack/conformance.sh $conformance_config
  fi
)
