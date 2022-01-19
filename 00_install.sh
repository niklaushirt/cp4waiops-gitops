#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#       __________  __ ___       _____    ________            
#      / ____/ __ \/ // / |     / /   |  /  _/ __ \____  _____
#     / /   / /_/ / // /| | /| / / /| |  / // / / / __ \/ ___/
#    / /___/ ____/__  __/ |/ |/ / ___ |_/ // /_/ / /_/ (__  ) 
#    \____/_/      /_/  |__/|__/_/  |_/___/\____/ .___/____/  
#                                              /_/            
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------------------"
#  CP4WAIOPS 3.2 - CP4WAIOPS Installation
#
#
#  ©2022 nikh@ch.ibm.com
# ---------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------"
clear

echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo "  "
echo "  🚀 CloudPak for Watson AIOps 3.2 - CP4WAIOps Installation"
echo "  "
echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo "  "
echo "  "


export TEMP_PATH=~/aiops-install

# ---------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------"
# Do Not Edit Below
# ---------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------"






export CLUSTER_STATUS=$(oc status | grep "In project")
export CLUSTER_WHOAMI=$(oc whoami)

if [[ ! $CLUSTER_STATUS =~ "In project" ]]; then
      echo "❌ You are not logged into a Openshift Cluster."
      echo "❌ Aborting...."
      exit 1
else
      echo "✅ $CLUSTER_STATUS"
      echo "   as user $CLUSTER_WHOAMI"

fi

echo ""
echo ""
echo ""
echo ""

echo "  Initializing......"
export ARGOCD_NAMESPACE=$(oc get po -n openshift-gitops|grep openshift-gitops-server |awk '{print$1}')
echo "  ......."
export WAIOPS_NAMESPACE=$(oc get po -A|grep aimanager-operator |awk '{print$1}')
echo "  o....."
export EVTMGR_NAMESPACE=$(oc get po -A|grep noi-operator |awk '{print$1}')
echo "  oo....."
export RS_NAMESPACE=$(oc get ns robot-shop |awk '{print$1}')
echo "  ooo...."
export TURBO_NAMESPACE=$(oc get ns turbonomic |awk '{print$1}')
echo "  oooo..."
export AWX_NAMESPACE=$(oc get ns awx |awk '{print$1}')
echo "  ooooo.."
export LDAP_NAMESPACE=$(oc get po -n default| grep ldap |awk '{print$1}')
echo "  oooooo."
export DEMO_NAMESPACE=$(oc get po -A|grep demo-ui- |awk '{print$1}')
echo "  oooooo"
export HUMIO_NAMESPACE=$(oc get ns humio-logging |awk '{print$1}')
echo "  ✅ Done"







# ------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------
# Patch IAF Resources for ROKS
# ------------------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------------------
menu_INSTALL_AIMGR () {
      echo "--------------------------------------------------------------------------------------------"
      echo " 🚀  Install CP4WAIOPS AI Manager" 
      echo "--------------------------------------------------------------------------------------------"
      echo ""
      if [[ ! $WAIOPS_NAMESPACE == "" ]]; then
            echo "❗⚠️ CP4WAIOPS AI Manager seems to be installed already"

            read -p " ❗❓ Are you sure you want to continue? [y,N] " DO_COMM
            if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
                  echo "   ✅ Ok, continuing..."
                  echo ""
                  echo ""

            else
                  echo "    ❌ Aborting"
                  echo "--------------------------------------------------------------------------------------------"
                  echo  ""    
                  echo  ""
                  exit 1
            fi

      fi

      echo ""
      echo ""
      echo "  Enter CP4WAIOPS Pull token: "
      read TOKEN
      echo ""
      echo "You have entered the following Token:"
      echo $TOKEN
      echo ""
      read -p " ❗❓ Are you sure that this is correct? [y,N] " DO_COMM
      if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            read -p " ❗❓ Do you want to install demo content (highly recommended - OpenLdap and RobotShop)? [Y,n] " DO_COMM
            if [[ $DO_COMM == "n" ||  $DO_COMM == "N" ]]; then
                  echo "   ✅ Ok, continuing without demo content..."
                  echo ""
                  echo ""

                  echo ""
                  ./argocd/11_install_ai_manager.sh -t $TOKEN
                 
            else
                  echo "   ✅ Ok, continuing with demo content..."
                  echo ""
                  echo ""

                  echo ""
                  ./argocd/11_install_ai_manager.sh -t $TOKEN  
                  ./argocd/32_install_ldap.sh
                  ./argocd/33_addons_robotshop.sh
            fi
      else
            echo "    ⚠️  Skipping"
            echo "--------------------------------------------------------------------------------------------"
            echo  ""    
            echo  ""
      fi
}




menu_INSTALL_EVTMGR () {
      echo "--------------------------------------------------------------------------------------------"
      echo " 🚀  Install CP4WAIOPS Event Manager" 
      echo "--------------------------------------------------------------------------------------------"
      echo ""
      if [[ ! $EVTMGR_NAMESPACE == "" ]]; then
            echo "❗⚠️ CP4WAIOPS Event Manager seems to be installed already"

            read -p " ❗❓ Are you sure you want to continue? [y,N] " DO_COMM
            if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
                  echo "   ✅ Ok, continuing..."
                  echo ""
                  echo ""

            else
                  echo "    ❌ Aborting"
                  echo "--------------------------------------------------------------------------------------------"
                  echo  ""    
                  echo  ""
                  exit 1
            fi

      fi

      echo ""
      echo ""
      echo "  Enter CP4WAIOPS Pull token: "
      read TOKEN
      echo ""
      echo "You have entered the following Token:"
      echo $TOKEN
      echo ""
      read -p " ❗❓ Are you sure that this is correct? [y,N] " DO_COMM
      if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
            echo ""

            echo ""
            ./argocd/12_install_event_manager.sh -t $TOKEN

      else
            echo "    ⚠️  Skipping"
            echo "--------------------------------------------------------------------------------------------"
            echo  ""    
            echo  ""
      fi
}




menu_INSTALL_HUMIO () {
      echo "--------------------------------------------------------------------------------------------"
      echo " 🚀  Install Humio" 
      echo "--------------------------------------------------------------------------------------------"
      echo ""
      if [[ ! $HUMIO_NAMESPACE == "" ]]; then
            echo "❗⚠️ Humio seems to be installed already"

            read -p " ❗❓ Are you sure you want to continue? [y,N] " DO_COMM
            if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
                  echo "   ✅ Ok, continuing..."
                  echo ""
                  echo ""

            else
                  echo "    ❌ Aborting"
                  echo "--------------------------------------------------------------------------------------------"
                  echo  ""    
                  echo  ""
                  exit 1
            fi

      fi

      echo ""
      echo ""
      echo "  Enter Humio License: "
      read TOKEN
      echo ""
      echo "You have entered the following license:"
      echo $TOKEN
      echo ""
      read -p " ❗❓ Are you sure that this is correct? [y,N] " DO_COMM
      if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
            echo "   ✅ Ok, continuing..."
            echo ""
            echo ""

            echo ""
            ./argocd/22_addons_humio.sh -l $TOKEN

      else
            echo "    ⚠️  Skipping"
            echo "--------------------------------------------------------------------------------------------"
            echo  ""    
            echo  ""
      fi
}


incorrect_selection() {
      echo "--------------------------------------------------------------------------------------------"
      echo " ❗ This option does not exist!" 
      echo "--------------------------------------------------------------------------------------------"
}


clear

echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo "      __________  __ ___       _____    ________            "
echo "     / ____/ __ \/ // / |     / /   |  /  _/ __ \____  _____"
echo "    / /   / /_/ / // /| | /| / / /| |  / // / / / __ \/ ___/"
echo "   / /___/ ____/__  __/ |/ |/ / ___ |_/ // /_/ / /_/ (__  ) "
echo "   \____/_/      /_/  |__/|__/_/  |_/___/\____/ .___/____/  "
echo "                                             /_/            "
echo "***************************************************************************************************************************************************"


echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo " 🚀 CloudPak for Watson AIOPs - INSTALL"
echo "*****************************************************************************************************************************"
echo "  "
echo "  ℹ️  This script provides different options to install CP4WAIOPS demo environments through OpenShift GitOps(ArgoCD)"
echo ""
echo ""

if [[  $ARGOCD_NAMESPACE =~ "openshift-gitops" ]]; then

      echo "    -----------------------------------------------------------------------------------------------------------------------------------------------"
      echo "    -----------------------------------------------------------------------------------------------------------------------------------------------"
      echo "    🚀 Connect to OpenShift GitOps to check your deployments"
      echo "    -----------------------------------------------------------------------------------------------------------------------------------------------"
      echo "    -----------------------------------------------------------------------------------------------------------------------------------------------"
      echo "    "
      echo "    🌏 URL:      https://$(oc get route -n  openshift-gitops  openshift-gitops-server -o jsonpath={.spec.host})"
      echo "  "
      echo "    🧔 User:       admin"
      echo "    🔐 Password:   "$(oc get secret -n openshift-gitops openshift-gitops-cluster -o "jsonpath={.data['admin\.password']}"| base64 --decode)
      echo "  "
fi

echo "  "
echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo "  "




until [ "$selection" = "0" ]; do
  
  echo ""
  

echo "  📥 Prerequisites Install"
if [[ ! $ARGOCD_NAMESPACE =~ "openshift-gitops" ]]; then
      echo "    	1  - Install Openshift GitOps                                 - Install OpenShift GitOps/ArgoCD"
else
      echo "    	✅  - Install Openshift GitOps                                "
fi

echo "    	2  - Install Prerequisites Mac                                - Install Prerequisites for Mac"
echo "    	3  - Install Prerequisites Ubuntu                             - Install Prerequisites for Ubuntu"
echo "  "
if [[ $ARGOCD_NAMESPACE =~ "openshift-gitops" ]]; then

      echo "  🚀 CP4WAIOPS - Base Install"
      if [[ $WAIOPS_NAMESPACE == "" ]]; then
            echo "    	11  - Install AI Manager                                      - Install CP4WAIOPS AI Manager Component"
      else
            echo "    	✅  - Install AI Manager                                      "
      fi

      if [[ ! $EVTMGR_NAMESPACE =~ "openshift-gitops" ]]; then
            echo "    	12  - Install Event Manager                                   - Install CP4WAIOPS Event Manager Component"
      else
            echo "    	✅  - Install Event Manager                                   "
      fi

      echo "  "
      echo "  🌏 Solutions"

      if [[ $TURBO_NAMESPACE == "" ]]; then
            echo "    	21  - Install Turbonomic                                      - Install Turbonomic (needs a separate license)"
      else
            echo "    	✅  - Install Turbonomic                                      "
      fi

      if [[  $HUMIO_NAMESPACE == "" ]]; then
            echo "    	22  - Install Humio                                           - Install Humio (needs a separate license)"
      else
            echo "    	✅  - Install Humio                                           "
      fi


      if [[  $AWX_NAMESPACE == "" ]]; then
            echo "    	23  - Install AWX                                             - Install AWX (open source Ansible Tower)"
      else
            echo "    	✅  - Install AWX                                             "
      fi

      # if [[  $EVTMGR_NAMESPACE == "" ]]; then
      #       echo "    	24  - Install OpenShift Mesh                                  - Install OpenShift Mesh (Istio)"
      # else
      #       echo "    	✅  - Install OpenShift Mesh                                  "
      # fi




      #       echo "    	25  - Install OpenShift Logging                               - Install OpenShift Logging (ELK)"
      echo "  "
      echo "  📛 CP4WAIOPS Addons"


      if [[  $DEMO_NAMESPACE == "" ]]; then
            echo "    	31  - Install CP4WAIOPS Demo Application                      - Install CP4WAIOPS Demo Application"
      else
            echo "    	✅  - Install CP4WAIOPS Demo Application                      "
      fi


      if [[  $LDAP_NAMESPACE == "" ]]; then
            echo "    	32  - Install OpenLdap                                        - Install OpenLDAP for CP4WAIOPS (should be installed by option 10)"
      else
            echo "    	✅  - Install OpenLdap                                        "
      fi

      if [[  $RS_NAMESPACE == "" ]]; then
            echo "    	33  - Install RobotShop                                       - Install RobotShop for CP4WAIOPS (should be installed by option 10)"
      else
            echo "    	✅  - Install RobotShop                                       "
      fi
else
echo "***************************************************************************************************************************************************"

      echo "  ❗ All other options are disabled until OpenShift GitOps has been  installed"
      echo "***************************************************************************************************************************************************"

fi
  echo "      "
  echo "      "
  echo "      "
  echo "    	0  -  Exit"
  echo ""
  echo ""
  echo "  Enter selection: "
  read selection
  echo ""
  case $selection in
    1 ) clear ; ./argocd/01_install_gitops.sh  ;;
    2 ) clear ; ./argocd/02_install_prerequisites_mac.sh  ;;
    3 ) clear ; ./argocd/03_install_prerequisites_ubuntu.sh  ;;
    11 ) clear ; menu_INSTALL_AIMGR  ;;
    12 ) clear ; menu_INSTALL_EVTMGR  ;;
    21 ) clear ; ./argocd/21_addons_turbonomic.sh  ;;
    22 ) clear ; menu_INSTALL_HUMIO  ;;
    23 ) clear ; ./argocd/23_addons_awx.sh  ;;
    24 ) clear ; ./argocd/24_addons_istio.sh  ;;
    25 ) clear ; ./argocd/25_addons_elk.sh  ;;
    28 ) clear ; menu_enable_zen_traffic  ;;


    31 ) clear ; ./argocd/31_aiops-demo-ui.sh  ;;
    32 ) clear ; ./argocd/32_install_ldap.sh  ;;
    33 ) clear ; ./argocd/33_addons_robotshop.sh  ;;


    0 ) clear ; exit ;;
    * ) clear ; incorrect_selection  ;;
  esac
  read -p "Press Enter to continue..."
  clear 
done


