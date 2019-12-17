#!/usr/bin/env bash

set -e

declare -A IMAGES
IMAGES[k8s-1.16.2]="k8s-1.16.2@sha256:5bae6a5f3b996952c5ceb4ba12ac635146425909801df89d34a592f3d3502b0c"
IMAGES[k8s-1.15.1]="k8s-1.15.1@sha256:14d7b1806f24e527167d2913deafd910ea46e69b830bf0b094dde35ba961b159"
IMAGES[k8s-1.14.6]="k8s-1.14.6@sha256:ec29c07c94fce22f37a448cb85ca1fb9215d1854f52573316752d19a1c88bcb3"
IMAGES[k8s-1.13.3]="k8s-1.13.3@sha256:afbdd9b4208e5ce2ec327f302c336cea3ed3c22488603eab63b92c3bfd36d6cd"
IMAGES[k8s-1.11.0]="k8s-1.11.0@sha256:696ba7860fc635628e36713a2181ef72568d825f816911cf857b2555ea80a98a"
IMAGES[k8s-genie-1.11.1]="k8s-genie-1.11.1@sha256:19af1961fdf92c08612d113a3cf7db40f02fd213113a111a0b007a4bf0f3f7e7"
IMAGES[k8s-multus-1.13.3]="k8s-multus-1.13.3@sha256:c0bcf0d2e992e5b4d96a7bcbf988b98b64c4f5aef2f2c4d1c291e90b85529738"
IMAGES[gocli]="gocli@sha256:f5543a427a0e4c83b7251fbf71aa9d562f80f182e8662f5a4df13beb9c8aaba8"
export IMAGES

image="${IMAGES[$KUBEVIRT_PROVIDER]:-${KUBEVIRT_PROVIDER}:prepublish}"
export image

