FROM ubuntu:xenial

LABEL version="1.0"

MAINTAINER Marc Peña Segarra <segarrra@gmail.com>

# Tell debconf to run in non-interactive mode (but just during the image build).
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
        apt-get dist-upgrade -yf && \
        apt-get update && \
        apt-get install -y \
        build-essential libtool libtalloc-dev shtool autoconf automake git-core pkg-config make gcc libpcsclite-dev \
        libtool shtool automake autoconf git-core pkg-config make gcc \
        build-essential libgmp3-dev libmpfr-dev libx11-6 libx11-dev texinfo flex bison libncurses5 \
        libncurses5-dbg libncurses5-dev libncursesw5 libncursesw5-dbg libncursesw5-dev zlibc zlib1g-dev libmpfr4 libmpc-dev libgnutls-dev \
        git wget zip unzip telnet && \
        apt-get clean && \
        apt-get autoremove && \
        rm -rf /var/lib/apt/lists/* && \
        cd

# ---
# libosmocore
RUN git clone git://git.osmocom.org/libosmocore.git && \
        cd libosmocore && \
        autoreconf -i && \
        ./configure && \
        make && \
        make install && \
        ldconfig -i
# ---
# GNU ARM toolchain
# https://osmocom.org/projects/baseband/wiki/GnuArmToolchain
RUN mkdir -p gnu-arm && \
        cd gnu-arm && \
        wget https://osmocom.org/attachments/download/2052/gnu-arm-build.3.sh && \
        chmod a+rx gnu-arm-build.3.sh && \
        mkdir build install src && \
        cd src && \
        wget http://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2 && \
        wget http://ftp.gnu.org/gnu/binutils/binutils-2.21.1a.tar.bz2 && \
        wget ftp://sourceware.org/pub/newlib/newlib-1.19.0.tar.gz && \
        cd .. && \
        ./gnu-arm-build.3.sh && \
        rm /gnu-arm/src/gcc-4.8.2.tar.bz2 /gnu-arm/src/binutils-2.21.1a.tar.bz2 /gnu-arm/src/newlib-1.19.0.tar.gz

RUN echo export PATH=$PATH:/gnu-arm/install/bin >> /etc/bash.bashrc

# ---
# osmocom-bb
RUN git clone git://git.osmocom.org/osmocom-bb.git && \
        cd osmocom-bb && \
        git pull --rebase && \
        cd src && \
        PATH=/gnu-arm/install/bin:$PATH make

# Fix firt mobile run
RUN mkdir -p /root/.osmocom/bb/ && \
        touch /root/.osmocom/bb/mobile.cfg

ENTRYPOINT  ["/bin/bash"]
