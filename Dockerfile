FROM alpine
USER root
RUN addgroup sftponly
RUN apk add openssh openrc jq
RUN rc-update add sshd
RUN rc-status 
RUN ssh-keygen -A
COPY ./sshd_config /etc/ssh/sshd_config

WORKDIR /app
COPY users.json users.json
COPY entrypoint.sh entrypoint.sh
COPY configuser.sh configuser.sh

EXPOSE 22000
CMD ["/app/entrypoint.sh", "/app"]
