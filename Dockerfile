FROM ubuntu:rolling

ENV SDK_URL "https://archive.openwrt.org/releases/18.06.4/targets/mvebu/cortexa9/openwrt-sdk-18.06.4-mvebu-cortexa9_gcc-7.3.0_musl_eabi.Linux-x86_64.tar.xz" 
ENV SDK_SUFFIX .tar.xz

RUN apt-get update
RUN apt-get install -y git-core subversion wget bzip2 unzip \
    gcc g++ make ccache libncurses5-dev zlib1g-dev \
    python gawk sudo groff-base
RUN apt-get install -y build-essential libncursesw5-dev python unzip rsync
RUN useradd -m openwrt
RUN echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt
USER openwrt
WORKDIR /home/openwrt
RUN git clone https://github.com/openwrt/openwrt.git
#RUN wget $SDK_URL
#RUN tar xf "$(basename $SDK_URL)"
#RUN rm "$(basename $SDK_URL)"
#RUN mv $(basename $SDK_URL $SDK_SUFFIX) openwrt
WORKDIR /home/openwrt/openwrt
RUN git checkout openwrt-18.06
RUN ./scripts/feeds update -a
RUN ./scripts/feeds install -a
COPY .config .config
RUN make tools/install -j4
RUN make toolchain/install -j4
