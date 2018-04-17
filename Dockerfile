FROM centos:centos7

MAINTAINER Jeremy Crafts <jcrafts@redhat.com>

LABEL com.redhat.component="insights-ocp-scanner-container"
LABEL name="containers/insights-ocp-scanner"
LABEL version="0.1"
LABEL summary="Scanner container for Red Hat Insights on Openshift"

COPY . /
ENV GOPATH=/go
ENV EGG=/etc/insights-client/rpm.egg

WORKDIR /go/src/github.com/RedHatInsights/insights-ocp-scanner

RUN yum install -y golang git && \
    yum install -y ../../../../../insights-client-3.0.2-2.fc25.noarch.rpm && \
    yum clean all && \
    go build -o insights-scanner

ENTRYPOINT ["./insights-scanner"]
