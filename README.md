# OpenShift ServiceMesh (Deployment Scripts)

This is a collection of Ansible playbooks and bash scripts to deploy the OpenShift ServiceMesh in an OpenShift 3.11 cluster.

Tested with OpenShift ServiceMesh TechPreview 9


# How to deploy


- Update Admission Config in OCP masters config  

`ansible-playbook -i /path/to/inventory_file 1.0_master_patch.yaml`

- Sysctl optimizations for ElasticSearch

`ansible-playbook -i /path/to/inventory_file 1.1_nodes_sysctl_es_update.yaml`

- Create new Project for ServiceMesh Operator
`./3.0_create_servicemesh_project.sh`

- Deploy ServiceMesh Operator

`./3.1_deploy_servicemesh_operator.sh`

- Validate depoloyment of Operation completed

`./4.0_check_istio_operator.sh`

- Update file with the credentials. Required:
 - OpenShift credentials with admin privileges
 - Kiali Dashoard credentials (you will use this to login into Kiali)

`oc create -f 5.0_oc_create_custom_resource_istio_installation-UPDATE_THIS.yaml`

- Watch for the deployment to complete (it takes about 10 minutes)

`./6.0_oc_get_pods_istio_system.sh`

Wait until you see the `openshift-ansible-istio-installer-job-xxxxx` goes into `Comleted` state.

Break out of the watch script (CTRL-C) and list the pods in the ServiceMesh project. 

`oc get pods -n istio-system`

Output must be similar to the following output (names will vary)

```
NAME                                          READY     STATUS      RESTARTS   AGE
elasticsearch-0                               1/1       Running     0          1m
grafana-74b5796d94-2c2mx                      1/1       Running     0          1m
istio-citadel-6db56d996-tdvn9                 1/1       Running     0          2m
istio-egressgateway-699b986dc8-dq8ts          1/1       Running     0          2m
istio-galley-6b6566bdb9-vlzfn                 1/1       Running     0          2m
istio-ingressgateway-7f8dd8f46f-tsjrx         1/1       Running     0          2m
istio-pilot-7d56bc5c47-rw2td                  2/2       Running     0          2m
istio-policy-7c4f7d6c5b-6hq6p                 2/2       Running     3          2m
istio-sidecar-injector-6cc5448dbc-qt2gg       1/1       Running     0          2m
istio-telemetry-9d7b5b6f9-xdnrd               2/2       Running     2          2m
jaeger-agent-7qw9x                            1/1       Running     0          1m
jaeger-agent-mdl52                            1/1       Running     0          1m
jaeger-agent-sqglw                            1/1       Running     0          1m
jaeger-collector-7f95d99756-k5p9f             1/1       Running     2          1m
jaeger-query-cfb5ccc6-xl2nh                   1/1       Running     1          1m
kiali-7557d6cf7c-rz5c6                        1/1       Running     0          33s
openshift-ansible-istio-installer-job-vjl76   0/1       Completed   0          5m
prometheus-75b849445c-hf4cf                   1/1       Running     0          2m
```

Break out of the watch (CTRL-C) 

## Testing the deployment

- Deploy Demo BookInfo App

`7.0_bookinfo_app.sh`

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


