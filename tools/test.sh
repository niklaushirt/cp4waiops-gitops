echo "Starting..."
export WAIOPS_NAMESPACE=$(oc get po -A|grep aimanager-operator |awk '{print$1}')
export EVTMGR_NAMESPACE=$(oc get po -A|grep noi-operator |awk '{print$1}')
CLUSTER_ROUTE=$(oc get routes console -n openshift-console | tail -n 1 2>&1 ) 
CLUSTER_FQDN=$( echo $CLUSTER_ROUTE | awk '{print $2}')
CLUSTER_NAME=${CLUSTER_FQDN##*console.}


export EVTMGR_REST_USR=$(oc get secret aiops-topology-asm-credentials -n $WAIOPS_NAMESPACE -o=template --template={{.data.username}} | base64 --decode)
export EVTMGR_REST_PWD=$(oc get secret aiops-topology-asm-credentials -n $WAIOPS_NAMESPACE -o=template --template={{.data.password}} | base64 --decode)

#oc delete route topology-rest -n $WAIOPS_NAMESPACE 
#oc create route passthrough topology-rest -n $WAIOPS_NAMESPACE --insecure-policy="Redirect" --service=aiops-topology-rest-observer --port=https-rest-observer-api

export LOGIN="$EVTMGR_REST_USR:$EVTMGR_REST_PWD"

echo "URL: https://topology-rest-$WAIOPS_NAMESPACE.$CLUSTER_NAME/1.0/rest-observer/rest/resources"
echo "LOGIN: $LOGIN"



#echo curl -X "POST" "https://topology-rest-$WAIOPS_NAMESPACE.$CLUSTER_NAME/1.0/rest-observer/rest/resources" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "robotshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["web"],"matchTokens": ["web","web-deployment"],"name": "web","namespace": "robot-shop","readyReplicas": 1,"tags": ["app:robotshop","namespace:robot-shop"],"vertexType": "resource","uniqueId": "web-id"}'



# -------------------------------------------------------------------------------------------------------------------------------------------------
# CREATE EDGES
# -------------------------------------------------------------------------------------------------------------------------------------------------
curl -X "GET" "https://topology-rest-$WAIOPS_NAMESPACE.$CLUSTER_NAME/1.0/rest-observer/jobs" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "robotshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["web"],"matchTokens": ["web","web-deployment","web-synthetic","web-instana"],"name": "web","namespace": "robot-shop","readyReplicas": 1,"tags": ["app:robotshop","namespace:robot-shop"],"vertexType": "resource","uniqueId": "web-id"}'
echo "."
curl -X "GET" "https://topology-rest-$WAIOPS_NAMESPACE.$CLUSTER_NAME/1.0/rest-observer/jobs/listenJob" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "robotshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["web"],"matchTokens": ["web","web-deployment","web-synthetic","web-instana"],"name": "web","namespace": "robot-shop","readyReplicas": 1,"tags": ["app:robotshop","namespace:robot-shop"],"vertexType": "resource","uniqueId": "web-id"}'

curl -X "POST" "https://topology-rest-$WAIOPS_NAMESPACE.$CLUSTER_NAME/1.0/rest-observer/jobs" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"unique_id":"listenJob","description":"","listen_job":true,"jobParameters":{"provider":"listenJob"}}'
echo "."
curl -X "GET" "https://topology-rest-$WAIOPS_NAMESPACE.$CLUSTER_NAME/1.0/rest-observer/jobs" --insecure -H 'Content-Type: application/json' -u $LOGIN -H 'JobId: listenJob' -H 'X-TenantID: cfd95b7e-3bc7-4006-a4a8-a73a79c71255' -d $'{"app": "robotshop","availableReplicas": 1,"createdReplicas": 1,"dataCenter": "demo","desiredReplicas": 1,"entityTypes": ["deployment"],"mergeTokens": ["web"],"matchTokens": ["web","web-deployment","web-synthetic","web-instana"],"name": "web","namespace": "robot-shop","readyReplicas": 1,"tags": ["app:robotshop","namespace:robot-shop"],"vertexType": "resource","uniqueId": "web-id"}'

echo "."
