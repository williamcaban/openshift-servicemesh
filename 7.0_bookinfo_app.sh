#!/bin/sh
DEMOPROJECT=istio-demo

oc new-project ${DEMOPROJECT} --display-name="ServiceMesh Demo"

echo "Update SSC for Service Account in project ${DEMOPROJECT}"
oc adm policy add-scc-to-user anyuid -z default -n ${DEMOPROJECT}
oc adm policy add-scc-to-user privileged -z default -n ${DEMOPROJECT}

oc apply -n ${DEMOPROJECT} -f https://raw.githubusercontent.com/Maistra/bookinfo/master/bookinfo.yaml
oc apply -n ${DEMOPROJECT} -f https://raw.githubusercontent.com/Maistra/bookinfo/master/bookinfo-gateway.yaml


export GATEWAY_URL=$(oc get route -n istio-system istio-ingressgateway -o jsonpath='{.spec.host}')
echo "The ServiceMesh Demo is available at: http://${GATEWAY_URL}/productpage"
