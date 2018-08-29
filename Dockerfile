FROM ubuntu:14.04.5
MAINTAINER Yang Sen <nuaays@gmail.com>

ENV TZ=Asia/Shanghai
ENV TERM=xterm
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/bin
ENV PASSWORD=nuaays

COPY ./oh-my-zsh    /root/.oh-my-zsh

RUN mkdir -p /root/.ssh/ /var/run/sshd && \
    echo  'tty -s && mesg n' > /root/.profile && \
    echo 'deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse                 \n\
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse        \n\
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse         \n\
deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse        \n\
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse       \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse             \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse    \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse     \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse    \n\
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse      ' > /etc/apt/sources.list && \
    echo 'echo root:${PASSWORD} | chpasswd' > /start.sh && \
    echo '/usr/sbin/sshd -D' >> /start.sh && \
    chmod +x /start.sh


RUN apt-get update && apt-get install -y openssh-server net-tools bash zsh tzdata dnsutils vim git wget curl unzip htop lnav && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    echo root:$PASSWORD | chpasswd && \
    rm -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -P '' -N '' && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    rm /dev/ptmx && \
    mknod -m 666 /dev/ptmx c 5 2 && \
    cp -f /root/.oh-my-zsh/templates/zshrc.zsh-template /root/.zshrc && \
    chsh -s /bin/zsh && \
    bash /root/.oh-my-zsh/tools/install.sh && \
    rm -r /var/lib/apt/lists/* /opt


EXPOSE 22


#CMD ["/usr/sbin/sshd", "-D"]
CMD ["/bin/zsh", "/start.sh"]
