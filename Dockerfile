FROM registry.access.redhat.com/ubi8/ubi-minimal

ENV LANG=en_US.UTF-8

RUN microdnf install python3 tar gzip &&\
    microdnf clean all &&\
    rm -fr /var/cache/lib/{dnf,rpm}

COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir --no-cache --upgrade pip && pip install --no-cache-dir --no-cache --upgrade wheel
RUN pip3 install --no-cache-dir --no-cache -r /tmp/requirements.txt
RUN curl https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.4/linux/oc.tar.gz -o - | tar -zx  -C /usr/bin

RUN mkdir -p /home/scaler/ /var/lib/f8a-scaler/

RUN echo 1 > /var/lib/f8a-scaler/liveness && \
    echo 0 > /var/lib/f8a-scaler/liveness_prev && \
    chmod 666 /var/lib/f8a-scaler/liveness /var/lib/f8a-scaler/liveness_prev

COPY scale.sh sqs_status.py liveness_check.sh /home/scaler/

WORKDIR /home/scaler

CMD bash scale.sh
