FROM ubuntu:bionic
LABEL maintainer="Ryan Duncan"

# Install system requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    openssh-server \
    pwgen 

# Configure locales and timezone
#RUN locale-gen en_US.UTF-8 en_GB.UTF-8 fr_CH.UTF-8 && \
#    cp /usr/share/zoneinfo/Europe/Zurich /etc/localtime && \
#    echo "Europe/Zurich" > /etc/timezone

RUN sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config 
RUN sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN mkdir -p /var/run/sshd 

# s6 install and config
#COPY bin/* /usr/bin/
#COPY configs/etc/s6 /etc/s6/
#RUN chmod a+x /usr/bin/s6-* && \
#    chmod a+x /etc/s6/.s6-svscan/finish /etc/s6/sshd/run /etc/s6/sshd/finish

# install setup scripts
COPY scripts/* /opt/
RUN chmod a+x /opt/setupusers.sh

# setup shell environment
COPY configs/tmux/tmux.conf /root/.tmux.conf
RUN echo 'PAGER=less' >> /root/.bashrc && \
    echo 'TERM=xterm' >> /root/.bashrc && \
    echo 'PS1="\[\e[32m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[32m\]:\[\e[m\]\[\e[34m\]\W\[\e[m\] \[\e[34m\]\\$\[\e[m\] "' >> /root/.bashrc && \
    echo '#[ -z "$TMUX" ] && command -v tmux > /dev/null && tmux && exit 0' >> /root/.bashrc

EXPOSE 22

COPY ./entrypoint.sh /sbin
RUN ["chmod", "+x", "/sbin/entrypoint.sh"]


ENTRYPOINT ["sh","entrypoint.sh"]
