FROM ubuntu:jammy

RUN DEBIAN_FRONTEND=noninteractive apt update;
RUN DEBIAN_FRONTEND=noninteractiveapt apt install -y lsb-release wget gnupg zsh

ENV HOSTNAME $hostname

CMD ["/bin/zsh"]
