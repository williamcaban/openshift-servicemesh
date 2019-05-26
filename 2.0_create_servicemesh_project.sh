#!/bin/sh

echo "Creating new Project/Namespace for OpenShift ServiceMesh Operator"
oc new-project istio-operator --description="OpenShift ServiceMesh Operator"
oc new-project istio-system   --description="OpenShift ServiceMesh System"

