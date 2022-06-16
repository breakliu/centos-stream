FROM registry.access.redhat.com/ubi8:latest
ARG ARCH=x86_64

RUN dnf download --repofrompath=centos,https://mirrors.tencent.com/centos/8-stream/BaseOS/$ARCH/os/ --disablerepo=* --enablerepo=centos centos-stream-release centos-stream-repos centos-gpg-keys \
    && rpm -ivh --nodeps --replacefiles *.rpm && rm *.rpm \
    && rpm -e redhat-release \
    && dnf --setopt=tsflags=nodocs --setopt=install_weak_deps=false -y distro-sync \
    && dnf remove -y subscription-manager dnf-plugin-subscription-manager\
    && dnf clean all \
    && rm -f /etc/yum.repos.d/ubi.repo \

    && ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone \
    && curl https://mirrors.tencent.com/repo/centos8_base.repo --output /etc/yum.repos.d/CentOS-Base.repo \
    && sed -e 's|^mirrorlist=|#mirrorlist=|g' -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.tencent.com|g' -i.bak /etc/yum.repos.d/CentOS-*.repo \
    && sed -i "s/enabled=0/enabled=1/g" /etc/yum.repos.d/CentOS-Stream-PowerTools.repo \

    && dnf --nodocs -y install epel-release \
    && dnf -y update \
    && dnf clean all
