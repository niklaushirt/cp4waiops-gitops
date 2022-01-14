#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#       __________  __ ___       _____    ________            
#      / ____/ __ \/ // / |     / /   |  /  _/ __ \____  _____
#     / /   / /_/ / // /| | /| / / /| |  / // / / / __ \/ ___/
#    / /___/ ____/__  __/ |/ |/ / ___ |_/ // /_/ / /_/ (__  ) 
#    \____/_/      /_/  |__/|__/_/  |_/___/\____/ .___/____/  
#                                              /_/            
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------------------------------------------"
#  Installing CP4WAIOPS 3.2
#
#  CloudPak for Watson AIOps
#
#  ©2021 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
clear
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      __________  __ ___       _____    ________            "
echo "     / ____/ __ \/ // / |     / /   |  /  _/ __ \____  _____"
echo "    / /   / /_/ / // /| | /| / / /| |  / // / / / __ \/ ___/"
echo "   / /___/ ____/__  __/ |/ |/ / ___ |_/ // /_/ / /_/ (__  ) "
echo "   \____/_/      /_/  |__/|__/_/  |_/___/\____/ .___/____/  "
echo "                                             /_/            "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  🚀 CloudPak for Watson AIOps 3.2 - AI MANAGER Install "
echo "  "
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "  "
echo "  "
echo ""
echo ""
echo ""
echo ""
echo ""




echo "***************************************************************************************************************************************************"
echo "  "
echo "  🚀 Starting installation"
echo "  "
echo "***************************************************************************************************************************************************"

echo "  "
echo "***************************************************************************************************************************************************"
echo "  📥 Create Namespace"
oc create ns openshift-gitops

echo "  "
echo "***************************************************************************************************************************************************"
echo "  📥 Create Openshift GitOps Operator"
oc apply -n openshift-operators -f ./openshift-gitops/install/1_argocd_sub.yaml


while : ; do
    READY=$(oc get ClusterServiceVersion -n openshift-operators || true) 
    if [[ ! $READY  =~ "Succeeded" ]]; then
        echo "   🕦 Openshift GitOps Operator is not ready. Waiting for 10 seconds...." && sleep 10; 
    else
        echo "      ✅ OK"
        break
    fi
done

echo "  "
echo "***************************************************************************************************************************************************"
echo "  📥 Create Openshift GitOps Instance"
oc create clusterrolebinding argocd-admin --clusterrole=cluster-admin --serviceaccount=openshift-gitops:openshift-gitops-argocd-application-controller
oc create clusterrolebinding default-admin --clusterrole=cluster-admin --serviceaccount=cp4waiops:default
oc apply -n  openshift-gitops -f ./openshift-gitops/install/2_argocd_install.yaml


while : ; do
    READY=$(oc get ArgoCD -n openshift-gitops openshift-gitops -o jsonpath={.status}|| true) 
    if [[ ! $READY  =~ '"server":"Running"' ]]; then
        echo "   🕦 Openshift GitOps Instance is not ready. Waiting for 10 seconds...." && sleep 10; 
    else
        echo "      ✅ OK"
        break
    fi
done



echo "  "
echo "***************************************************************************************************************************************************"
echo "  🔐 Login Credentials"
echo "  "
echo "            🌏 URL:      https://$(oc get route -n  openshift-gitops  openshift-gitops-server -o jsonpath={.spec.host})"
echo "  "
echo "            🧔 User:       admin"
echo "            🔐 Password:   "$(oc get secret -n openshift-gitops openshift-gitops-cluster -o "jsonpath={.data['admin\.password']}"| base64 --decode)
echo "  "





exit 1

while : ; do
ai_ir=$(oc get AIOpsAnalyticsOrchestrator aiops -n {{.Values.spec.aiManager.namespace}} -o jsonpath={.kind})
if [[ $? != 0 ]]; then
    echo '"AIOpsAnalyticsOrchestrator" has not been created yet.'
    sleep 10s
else
    break
fi
done