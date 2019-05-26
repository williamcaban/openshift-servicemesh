#!/bin/sh

#oc get pods -n istio-system -w

# Note: using regular watch 
watch -cdx oc get pods -n istio-system
