FROM alpine:3.7

RUN apk add --no-cache \
    openssh \
    git

RUN ssh-keygen -A

RUN adduser -D -s /usr/bin/git-shell git \
    && mkdir -m 700 /home/git/.ssh/ \
    && mkdir /home/git/repos/ \
    && echo 'git:gitpassword' | chpasswd

COPY sshd_config /etc/ssh/sshd_config

COPY public_keys /home/git/.ssh/authorized_keys

COPY git-shell-commands/ /home/git/git-shell-commands/

RUN chmod 600 /home/git/.ssh/authorized_keys \
    && chown -R git:git /home/git/

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
