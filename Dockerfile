FROM alpine
USER root
RUN addgroup ftpaccess
RUN apk update
RUN apk add openssh-server-pam jq 
RUN ssh-keygen -A

COPY ./config/sshd_config /etc/ssh/sshd_config

WORKDIR /app

COPY users.json users.json

COPY ./scripts/entrypoint.sh entrypoint.sh
COPY ./scripts/configuser.sh configuser.sh

EXPOSE 22000
CMD ["/app/entrypoint.sh", "/app"]
