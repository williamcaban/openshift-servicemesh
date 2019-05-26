#!/bin/sh

echo "Deploying OpenShift ServiceMesh Operator"
oc apply -n istio-operator -f https://raw.githubusercontent.com/Maistra/istio-operator/maistra-0.10/deploy/servicemesh-operator.yaml
