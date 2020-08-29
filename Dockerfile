FROM alpine
USER root
RUN addgroup sftponly
RUN apk add openssh openrc jq rsyslog
RUN rc-update add sshd
RUN rc-update add rsyslog boot
RUN rc-status 
RUN ssh-keygen -A
COPY ./config/sshd_config /etc/ssh/sshd_config

WORKDIR /app
COPY users.json users.json
COPY ./scripts/entrypoint.sh entrypoint.sh
COPY ./scripts/configuser.sh configuser.sh

EXPOSE 22000
CMD ["/app/entrypoint.sh", "/app"]
