FROM registry.centos.org/centos/centos:7
MAINTAINER Tomas Hrcka <thrcka@redhat.com>

ENV LANG=en_US.UTF-8

RUN yum --setopt=tsflags=nodocs install -y epel-release centos-release-openshift-origin && \
    yum --setopt=tsflags=nodocs install -y cronie crontabs python34-pip wget python34-devel libxml2-devel libxslt-devel python34-requests python34-pycurl origin-clients && \
    yum clean all

COPY requirements.txt /tmp/
RUN pip3 install --upgrade pip && pip install --upgrade wheel && \
    pip3 install -r /tmp/requirements.txt

RUN mkdir -p /home/scaler/ /var/lib/f8a-scaler/

COPY scale.sh sqs_status.py liveness_check.sh /home/scaler/
COPY scalerjob /etc/cron.d/scalerjob

WORKDIR /home/scaler

RUN chmod 0644 /etc/cron.d/scalerjob && \
    chmod 0777 /var/lib/f8a-scaler/ && \
    chmod 0777 /var/run/

# Workaround centos crond problem
RUN sed -i '/session required pam_loginuid.so/d' /etc/pam.d/crond

RUN touch /var/log/cron.log && \
    echo 1 > /var/lib/f8a-scaler/liveness && \
    echo 0 > /var/lib/f8a-scaler/liveness_prev


CMD crond && tail -f /var/log/cron.log
