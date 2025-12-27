FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

#  基本的なツール
RUN apt-get update && apt-get install -y \
    curl gnupg2 lsb-release software-properties-common wget \
    && rm -rf /var/lib/apt/lists/*

# Universeリポジトリを有効化し、ROS 2のGPGキーとリポジトリを追加
RUN add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/cross-linux-aarch64/ /" > /etc/apt/sources.list.d/cuda-aarch64-cross.list && \
    apt-get update && \
    apt-get install -y cuda-toolkit-12-6 cuda-cross-aarch64-12-6 && \
    rm -rf /var/lib/apt/lists/* cuda-keyring_1.1-1_all.deb

# PATHにCUDAを追加
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64

# 開発ツール、クロスコンパイラ、ROS関連ツール
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3-pip \
    wget \
    rsync \
    crossbuild-essential-arm64 \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    qemu-user-static \
    ros-humble-ros-base \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/lib/aarch64-linux-gnu && \
    ln -s /sysroot/usr/lib/aarch64-linux-gnu/libpython3.10.so /usr/lib/aarch64-linux-gnu/libpython3.10.so

WORKDIR /workspace

RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
RUN echo 'alias jbuild="colcon build --merge-install --cmake-args -DCMAKE_TOOLCHAIN_FILE=/workspace/Toolchain.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/workspace/install"' >> /root/.bashrc
