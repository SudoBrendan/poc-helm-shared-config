FROM registry.access.redhat.com/ubi8:8.4

RUN curl -O https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz \
    && tar xvzf openshift-client-linux.tar.gz \
    && mv oc kubectl /usr/local/bin/ \
    && kubectl version --client \
    && oc version --client \
    && mkdir -p home/kube/.kube \
    && chgrp -R 0 /home/kube \
    && chmod -R g=u /home/kube

WORKDIR /app
COPY . .
RUN chgrp -R 0 . \
    && chmod -R g=u .

USER 1001
ENV HOME=/home/kube

CMD [ "/app/entrypoint.sh" ]