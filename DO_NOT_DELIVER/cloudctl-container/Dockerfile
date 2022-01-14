FROM quay.io/openshift/origin-cli:latest


RUN curl -L https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz -o cloudctl-linux-amd64.tar.gz
RUN tar xfvz cloudctl-linux-amd64.tar.gz
RUN mv cloudctl-linux-amd64 /usr/local/bin/cloudctl
RUN rm cloudctl-linux-amd64.tar.gz


