FROM centos:7
MAINTAINER horatiu@vlad.eu

RUN yum install -y epel-release && \
    yum -y install java-1.8.0-openjdk.x86_64 nss_wrapper && \
    yum clean all

COPY elasticsearch.repo /etc/yum.repos.d/elasticserach.repo

ENV USER elasticsearch
ENV HOME /usr/share/elasticsearch
ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV ELASTICSEARCH_VERSION 2.4.4-1

WORKDIR /usr/share/elasticsearch

RUN yum -y install elasticsearch-${ELASTICSEARCH_VERSION}.noarch && \
    yum clean all && \
    for path in ./data ./logs ./config ./config/scripts ; do \
        mkdir -p "$path" && chown -R $USER:root "$path"; \
    done

COPY passwd.in ${HOME}/
COPY config ./config
COPY entrypoint /

EXPOSE 9200 9300

RUN chmod -R ug+rwX /usr/share/elasticsearch
USER 1000

ENTRYPOINT ["/entrypoint"]
CMD ["elasticsearch"]
