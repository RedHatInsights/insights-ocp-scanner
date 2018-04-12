FROM rhel7:7.5-ondeck

MAINTAINER Jeremy Crafts <jcrafts@redhat.com>

LABEL com.redhat.component="insights-ocp-scanner-container"
LABEL name="containers/insights-ocp-scanner"
LABEL version="0.1"
LABEL summary="Scanner container for Red Hat Insights on Openshift"

COPY . /
ENV GOPATH=/go
ENV EGG=/etc/insights-client/rpm.egg

WORKDIR /go/src/github.com/RedHatInsights/insights-ocp-scanner

RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs && \
    yum install -y golang git && \
    yum install -y ../../../../../insights-client-3.0.2-2.fc25.noarch.rpm && \
    yum clean all && \
    go build -o insights-scanner

ENTRYPOINT ["./insights-scanner"]
