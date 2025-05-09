FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0
ENV HOME=/root

# 1. Instalar paquetes iniciales
RUN apt update && apt install -y \
    xfce4 xfce4-goodies x11vnc xvfb dbus-x11 \
    openssh-server python3 python3-pip \
    wget curl gnupg2 software-properties-common apt-transport-https ca-certificates \
    && apt clean

# 2. instalar vscode
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt update && apt install -y code

RUN mkdir /var/run/sshd

RUN echo '#!/bin/bash\n\
Xvfb :0 -screen 0 1280x800x24 &\n\
sleep 2\n\
dbus-launch startxfce4 &\n\
sleep 2\n\
x11vnc -display :0 -forever -nopw -shared -bg\n\
/usr/sbin/sshd -D' > /startup.sh && chmod +x /startup.sh
