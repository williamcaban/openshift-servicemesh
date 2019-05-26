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

Wait until you see the all the Pods remain in the `Running` state.

Break out of the watch script (CTRL-C) and list the pods in the ServiceMesh project. 

`oc get pods -n istio-system`

Output must be similar to the following output (names will vary)

```
NAME                                          READY     STATUS      RESTARTS   AGE
3scale-istio-adapter-7df4db48cf-sc98s         1/1       Running     0          13s
elasticsearch-0                               1/1       Running     0          29s
grafana-c7f5cc6b6-vg6db                       1/1       Running     0          33s
istio-citadel-d6d6bb7bb-jgfwt                 1/1       Running     0          1m
istio-egressgateway-69448cf7dc-b2qj5          1/1       Running     0          1m
istio-galley-f49696978-q949d                  1/1       Running     0          1m
istio-ingressgateway-7759647fb6-pfpd5         1/1       Running     0          1m
istio-pilot-7595bfd696-plffk                  2/2       Running     0          1m
istio-policy-779454b878-xg7nq                 2/2       Running     2          1m
istio-sidecar-injector-6655b6ffdb-rn69r       1/1       Running     0          1m
istio-telemetry-dd9595888-8xjz2               2/2       Running     2          1m
jaeger-agent-gmk72                            1/1       Running     0          25s
jaeger-collector-7f644df9f5-dbzcv             1/1       Running     1          25s
jaeger-query-6f47bf4777-h4wmh                 1/1       Running     1          25s
kiali-7cc48b6cbb-74gcf                        1/1       Running     0          17s
prometheus-5f9fd67f8-r6b86                    1/1       Running     0          1m
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


