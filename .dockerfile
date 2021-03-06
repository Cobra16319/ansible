FROM openshift/ose-base:ansible.runner
ENV __doozer=update BUILD_RELEASE=1 BUILD_VERSION=v3.11.272 OS_GIT_MAJOR=3 OS_GIT_MINOR=11 OS_GIT_PATCH=272 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=3.11.272-1 SOURCE_GIT_TREE_STATE=clean 
MAINTAINER Ansible Playbook Bundle Community

RUN yum -y install atomic-openshift-clients python-openshift ansible ansible-kubernetes-modules ansible-asb-modules apb-base-scripts git \
  && yum clean all


ENV USER_NAME=apb \
    USER_UID=1001 \
    BASE_DIR=/opt/apb
ENV HOME=${BASE_DIR}

RUN mkdir -p /usr/share/ansible/openshift              /etc/ansible /opt/ansible              ${BASE_DIR} ${BASE_DIR}/etc              ${BASE_DIR}/.kube ${BASE_DIR}/.ansible/tmp \
  && chown -R ${USER_NAME}:0 /opt/{ansible,apb} \
  && chmod -R g+rw /opt/{ansible,apb} ${BASE_DIR}

RUN sed "s@${USER_NAME}:x:${USER_UID}:@${USER_NAME}:x:\${USER_ID}:@g" /etc/passwd > ${BASE_DIR}/etc/passwd.template
WORKDIR /opt/apb
ENTRYPOINT ["entrypoint.sh"]

LABEL \
        com.redhat.component="openshift-enterprise-apb-base-container" \
        com.redhat.apb.runtime="2" \
        version="v3.11.272" \
        vendor="Red Hat" \
        name="openshift3/apb-base" \
        License="GPLv2+" \
        release="1" \
        io.openshift.maintainer.product="OpenShift Container Platform"
