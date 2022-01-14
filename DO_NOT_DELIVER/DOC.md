


aiops-ir-lifecycle-create-policies-job            0/1           93m        93m
aiops-ir-lifecycle-policy-registry-svc-job        0/1           93m        93m

oc get job -n cp4waiops aiops-ir-lifecycle-create-policies-job -o jsonpath={".status.conditions[].reason"}
oc delete job -n cp4waiops aiops-ir-lifecycle-create-policies-job

