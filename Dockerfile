FROM ubuntu:22.04

ARG VESC_RELEASE=6_05
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
# Install BLDC dependencies
RUN apt install -y git build-essential libgl-dev libxcb-xinerama0 wget git-gui gcc-arm-none-eabi python3

# Build BLDC firmware
WORKDIR /usr/app/
RUN git clone https://github.com/vedderb/bldc.git
WORKDIR /usr/app/bldc/
RUN git checkout release_${VESC_RELEASE}

COPY . /usr/app/vesc_tool
WORKDIR /usr/app/vesc_tool

RUN ./build_cp_fw

# Build VESC tool
RUN apt install -y qtbase5-dev \
                    qt5-qmake \
                    qtbase5-dev-tools \
                    qtbase5-private-dev \
                    qtdeclarative5-dev \
                    qtquickcontrols2-5-dev \
                    libqt5svg5-dev \
                    libqt5serialbus5-dev \
                    qtconnectivity5-dev \
                    qtpositioning5-dev \
                    libqt5gamepad5-dev \
                    libqt5serialport5-dev
RUN ./build_lin_original_only

WORKDIR /usr/app/vesc_tool/build/lin
RUN cp vesc_tool_6.06 /usr/bin/vesc_tool

ENTRYPOINT ["vesc_tool", "--offscreen", "--tcpServer 65102"]