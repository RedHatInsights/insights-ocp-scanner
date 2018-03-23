FROM centos:centos7

MAINTAINER Lindani Phiri <lphiri@redhat.com>

COPY ./insights-client-3.0.2-2.fc25.noarch.rpm  /insights-client-3.0.2-2.fc25.noarch.rpm

RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs && \
    yum install -y golang git && \
    yum install -y /insights-client-3.0.2-2.fc25.noarch.rpm && \
    yum clean all

ENV GOPATH=/go
RUN mkdir -p /go/src/github.com/RedHatInsights/insights-ocp/scanner
WORKDIR /go/src/github.com/RedHatInsights/insights-ocp/scanner

COPY ./insights-scanner.go ./insights-scanner.go
COPY ./vendor ./vendor

RUN go build -o insights-scanner

RUN rm /etc/insights-client/.fallback.json
RUN rm /etc/insights-client/insights-client.conf
COPY ./.fallback.json /etc/insights-client/.fallback.json
COPY ./insights-client.conf /etc/insights-client/insights-client.conf

ENV EGG=/etc/insights-client/rpm.egg

ENTRYPOINT ["./insights-scanner"]
