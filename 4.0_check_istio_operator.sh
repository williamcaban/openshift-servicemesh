#!/bin/sh

oc logs -n istio-operator $(oc -n istio-operator get pods -l name=istio-operator --output=jsonpath={.items..metadata.name})
