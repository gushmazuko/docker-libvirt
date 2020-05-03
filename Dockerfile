FROM fedora:32
MAINTAINER "gushmazuko" <gushmazuko@protonmail.com>
#ENV container docker

ENV SSH_PORT 2222
ENV SSH_PASSWORD_AUTH no
ENV SSH_ROOT_PASSWORD_AUTH no

RUN dnf -y upgrade --refresh && dnf clean all

RUN dnf -y install openssh-server; \
systemctl enable sshd

RUN dnf -y group install --with-optional virtualization; \
systemctl enable libvirtd; \
systemctl enable virtlockd

RUN touch /etc/sysconfig/network
RUN mkdir -p /var/lib/libvirt/images/

# Edit the service file which includes ExecStartPost to chmod /dev/kvm
RUN sed -i "/Service/a ExecStartPost=\/bin\/chmod 666 /dev/kvm" /usr/lib/systemd/system/libvirtd.service

VOLUME [ "/sys/fs/cgroup" ]

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]

CMD [ "/usr/sbin/init" ]
