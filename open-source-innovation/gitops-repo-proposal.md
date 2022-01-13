<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [GitOps Open Source Repo Proposal](#gitops-open-source-repo-proposal)
  - [Current Condition](#current-condition)
  - [Option 1 (Preferred)](#option-1-preferred)
  - [Option 2](#option-2)
  - [Option 3](#option-3)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# GitOps Open Source Repo Proposal

This is a follow up discussion for [Cloud Pak GitOps Support Strategy](https://github.ibm.com/IBMPrivateCloud/BedrockServices/blob/master/ArchitectureSpecifications/GItOpsStrategy.md).

As the GitOps request customer can fork the repo and update the repo based on their requirement and trace the changes in commit log, so for the Cloud Pak GitOps, we need to open source all of the repos for Cloud Pak GitOps.

## Current Condition

There are three GitHub Orgs/Repos doing the Cloud Pak GitOps.

- Org from @barcia’s team: https://github.com/cloud-native-toolkit/ This is focusing on some Cloud Native Tools including DevOps, GitOps, and some other tools for different IBM products.
- Repo created by @dnastaci: https://github.com/IBM/cloudpak-gitops This is a repo hosting all GitOps YAML templates for all Cloud Paks.
- Org cp4i-cloudpak: https://github.com/cp4i-cloudpak This org is focusing on CP4I GitOps.

The current GitOps work are split to different orgs and repos, and it is difficult to maintain and share with customers.

## Option 1 (Preferred)

- Have a central org in GitHub focusing on Cloud Pak GitOps? Like https://github.com/cloud-pak-gitops to host all the GitOps templates for different Cloud Paks, each Cloud Pak can have its own repos and this can enable that different repos can be maintained by different Cloud Pak Teams.

- Form a virtual CloudPakOps (Manage Your IBM Cloud Paks with GitOps) Guild and have regular meeting to sync up the progress for each Cloud Pak GitOps.

- For all the repos, we need follow the pattern as follows:
  - Follow the design by Denilson Nastacio at https://github.ibm.com/IBMPrivateCloud/BedrockServices/blob/master/ArchitectureSpecifications/GItOpsStrategy.md 
  - Leverage Roland’s team GitOps assets https://github.com/cloud-native-toolkit/?q=gitops&type=&language=&sort= as much as possible
  - Have regular meeting with different Cloud Pak owners to push the adoption of GitOps

  This option is clean and easy to maintain.

## Option 2

- Create all Repos under https://github.com/IBM , but using repo prefix like `gitops-` and labels to enable cusotmer can select repos to fork.
- In order to not mess up the GitOps repos and other repos under IBM org, we can create a index repo like https://github.com/IBM/ibm-cloudpak-index

## Option 3

- Leverage Roland’s team GitOp Org https://github.com/cloud-native-toolkit/ and create all repos there
- In order to not mess up the GitOps repos and other repos under cloud-native-toolkit org, we can create a index repo like https://github.com/IBM/ibm-cloudpak-index
