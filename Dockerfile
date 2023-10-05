FROM nvcr.io/nvidia/tensorflow:22.10-tf1-py3

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai LANG=C.UTF-8 LC_ALL=C.UTF-8 PIP_NO_CACHE_DIR=1

# Install apt packages
RUN sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list &&\
    sed -i "s/security.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list &&\
    rm -f /etc/apt/sources.list.d/* &&\
    apt-get update && apt-get upgrade -y &&\
    apt-get install -y --no-install-recommends \
        # Determined requirements and common tools
        autoconf automake autotools-dev build-essential ca-certificates \
        make cmake ninja-build pkg-config g++ ccache yasm \
        ccache doxygen graphviz plantuml \
        daemontools krb5-user ibverbs-providers libibverbs1 \
        libkrb5-dev librdmacm1 libssl-dev libtool \
        libnuma1 libnuma-dev libpmi2-0-dev \
        openssh-server openssh-client pkg-config nfs-common \
        ## Tools
        git curl wget unzip nano net-tools sudo htop iotop \
        cloc rsync xz-utils software-properties-common \
    && rm /etc/ssh/ssh_host_ecdsa_key \
    && rm /etc/ssh/ssh_host_ed25519_key \
    && rm /etc/ssh/ssh_host_rsa_key \
    && cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bak \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Install Python packages
WORKDIR /tmp
ENV PYTHONUNBUFFERED=1 PYTHONFAULTHANDLER=1 PYTHONHASHSEED=0
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ &&\
    pip install tf_slim &&\
    pip install scipy==1.1.0 &&\
    rm -rf /tmp/*