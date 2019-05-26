# OpenShift ServiceMesh (Deployment Scripts)

This is a collection of Ansible playbooks and bash scripts to deploy the OpenShift ServiceMesh in an OpenShift 3.11 cluster.

Tested with OpenShift ServiceMesh TechPreview 10 (Maistra 0.10)


# How to deploy


- Update Admission Config in OCP masters config  

`ansible-playbook -i /path/to/inventory_file 1.0_master_patch.yaml`

- Sysctl optimizations for ElasticSearch

`ansible-playbook -i /path/to/inventory_file 1.1_nodes_sysctl_es_update.yaml`

- Create new Project for ServiceMesh Operator

`./2.0_create_servicemesh_project.sh`

- Deploy ServiceMesh Operator

`./3.0_deploy_servicemesh_operator.sh`

- Validate depoloyment of Operation completed

`./4.0_check_istio_operator.sh`

- (optional) Update file with the credentials:
  - OpenShift credentials with admin privileges
  - Kiali Dashoard credentials (you will use this to login into Kiali)

`oc create -n istio-system -f 5.0_oc_create_custom_resource_istio_installation.yaml`

- Watch for the deployment to complete (it takes about 10 minutes)

`./6.0_oc_get_pods_istio_system.sh`

Wait until you see the all the Pods remain in the `Running` state. It may take from 10 to 15 minutes.

**NOTE:** It is normal to see some Pods going through `CrashLoops` or in `Error` state during the initialization. Once everything is stable, all the Pods should be in `Running` state.

Break out of the watch script (CTRL-C) and list the pods in the ServiceMesh project. 

`oc get pods -n istio-system`

Output must be similar to the following output (names will vary)

```
NAME                                      READY     STATUS    RESTARTS   AGE
elasticsearch-0                           1/1       Running   0          5m
grafana-6c5dfdf5bd-m74fp                  1/1       Running   0          5m
ior-679b475484-hz8wz                      1/1       Running   0          6m
istio-citadel-66cf447cbd-csmbg            1/1       Running   0          10m
istio-egressgateway-69b65dddf5-smptv      1/1       Running   0          6m
istio-galley-5dbd58568d-2r8sm             1/1       Running   0          9m
istio-ingressgateway-b688c9d9b-7g67v      1/1       Running   0          5m
istio-ingressgateway-b688c9d9b-7r7w4      1/1       Running   0          6m
istio-pilot-79668d4bf6-j6772              2/2       Running   0          7m
istio-policy-5f45fcf95f-xtd6b             2/2       Running   0          8m
istio-sidecar-injector-7c44bcbbcd-6swzx   1/1       Running   0          6m
istio-telemetry-7fcd854d6b-pljck          2/2       Running   0          8m
jaeger-agent-2v96r                        1/1       Running   0          5m
jaeger-agent-sxc58                        1/1       Running   0          5m
jaeger-agent-zj5jl                        1/1       Running   0          5m
jaeger-collector-576b66f88c-24gnf         1/1       Running   4          5m
jaeger-query-7549b87c55-4fhjz             1/1       Running   4          5m
kiali-7475849854-nr2b2                    1/1       Running   0          2m
prometheus-5dfcf8dcf9-6lrqq               1/1       Running   0          8m
```

## Testing the deployment

- Deploy Demo BookInfo App

`./7.0_bookinfo_app.sh`

- Identify Kiali dashboard route for your deployment 

```
oc get route kiali -n istio-system

NAME      HOST/PORT                             PATH      SERVICES   PORT         TERMINATION   WILDCARD
kiali     kiali-istio-system.apps.example.com             kiali      http-kiali   reencrypt     None
```

In this example the URL will be `https://kiali-istio-system.apps.example.com`

- Login with the credentials configured in step 5.0_...

- Select the `Graph` tab in the left pane.

- Select `istio-demo` on the 'Namespace' dropdown on the top of the central pane.

- Click `Display Unused Nodes` to see the microservices asociated to the BookInfo demo app. (Note: The application must be receiving traffic to see the actual Graph generation)

- Deploy `Job` to generate traffic towards the `Book Info` app

`oc create -f 8.1_oc_create_job.yaml`

- After 15 seconds the `Graph` view of the application should be populated


