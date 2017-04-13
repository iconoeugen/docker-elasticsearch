FROM centos:7
MAINTAINER Horatiu Eugen Vlad <info@vlad.eu>

RUN yum install -y epel-release && \
    yum -y install java-1.8.0-openjdk.x86_64 nss_wrapper && \
    yum clean all

ENV USER elasticsearch
ENV HOME /usr/share/elasticsearch
ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV ELASTICSEARCH_VERSION 2.4.4-1

COPY elasticsearch.repo /etc/yum.repos.d/elasticserach.repo
RUN yum -y install elasticsearch-${ELASTICSEARCH_VERSION}.noarch && \
    yum clean all

COPY passwd.in ${HOME}/
COPY config /usr/share/elasticsearch/config
COPY entrypoint /
RUN for path in /usr/share/elasticsearch ; do \
      chmod -R ug+rwX "$path" && mkdir -p "$path" && chown -R $USER:root "$path"; \
    done

EXPOSE 9200 9300
USER 1000

ENTRYPOINT ["/entrypoint"]
CMD ["elasticsearch"]
