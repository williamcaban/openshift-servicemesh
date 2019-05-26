#!/bin/sh

#oc get pods -n istio-system -w

# Note: using regular watch 
watch -d oc get pods -n istio-system
