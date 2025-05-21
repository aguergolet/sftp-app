FROM alpine
USER root
RUN groupadd appgroup && useradd -ms /bin/bash -g appgroup appuser
RUN addgroup ftpaccess
RUN apk update
RUN apk add sshguard nftables
RUN apk add openssh-server-pam jq 
RUN ssh-keygen -A

COPY ./config/sshguard.conf /etc/sshguard.conf
COPY ./config/sshd_config /etc/ssh/sshd_config

#configure nft
RUN echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
RUN echo "vm.swappiness = 10"  >> /etc/sysctl.conf

WORKDIR /app

COPY users.json users.json

COPY ./scripts/nftables_config.sh nftables_config.sh
COPY ./scripts/entrypoint.sh entrypoint.sh
COPY ./scripts/configuser.sh configuser.sh

RUN chown -R appuser:appgroup /app
RUN touch /app/sshguard.log /app/sshd.log && chown appuser:appgroup /app/sshguard.log /app/sshd.log
USER appuser


EXPOSE 22000
CMD ["/app/entrypoint.sh", "/app"]
