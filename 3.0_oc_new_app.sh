#!/bin/sh

# oc new-app -f 3b_istio_product_operator_template.yaml --param=OPENSHIFT_ISTIO_MASTER_PUBLIC_URL=https://ocp.example.com
oc new-app -f 3b_istio_product_operator_template.yaml
