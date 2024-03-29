FROM stereolabs/zed:ubuntu1604-cuda9.0-zed2.8-gl

ENV HOME /root

RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
        libx11-dev  \
        mesa-utils \
        x11-apps \
        ca-certificates \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        curl \
        vim && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*
    
# cuDNN version must match the one used by TensorRT.
# TRT 4.0 is compiled with cuDNN 7.1.
#########################################################################
RUN apt-get update && apt-get -y --no-install-recommends install \
        ca-certificates \
        build-essential \
        libcudnn7=7.1.4.18-1+cuda9.0 \
        libcudnn7-dev=7.1.4.18-1+cuda9.0 \
    && apt-get -y autoremove \
    && apt-get clean \
    # cleanup
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*
#########################################################################

# ROS Kinetic
# Use rosdep to install all dependencies (including ROS itself)
########################################################################################################################
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'  \
    && apt-get update && apt-get install -y ros-kinetic-desktop-full python-rosdep   \
    && apt-get update                                                                \
    && rosdep init                                                                   \
    && rosdep update                                                                 \
    && apt-get install -y ros-kinetic-rosbash ros-kinetic-ros-comm                   \
    && apt-get -y autoremove                                                         \
    && apt-get clean                                                                 \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*
#########################################################################


# Install Velodyne driver
#########################################################################
RUN apt-key del F42ED6FBAB17C654
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' \ 
                --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update && \
    apt-get install -y ros-kinetic-velodyne && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src/
RUN git clone https://github.com/ros-drivers/velodyne.git
#########################################################################

# Install realsense-ros
#########################################################################
RUN git clone https://github.com/IntelRealSense/realsense-ros.git
#########################################################################

RUN echo "source /opt/ros/kinetic/setup.bash" >> /root/.bashrc
RUN echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc
ARG DEBIAN_FRONTEND=noninteractive

# Install librealsense v2.29.0
#########################################################################
WORKDIR /
RUN apt-get update -y && \
    apt-get upgrade -y && \ 
    apt-get dist-upgrade -y && \
    apt-get install -y --install-recommends \
                       linux-generic-lts-xenial \
                       xserver-xorg-core-lts-xenial \
                       xserver-xorg-lts-xenial \
                       xserver-xorg-video-all-lts-xenial \
                       xserver-xorg-input-all-lts-xenial \
                       libwayland-egl1-mesa-lts-xenial \
                       libssl-dev \
                       libusb-1.0-0-dev \ 
                       pkg-config \ 
                       libgtk-3-dev \ 
                       libglfw3-dev && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p /Source/
WORKDIR /Source/
RUN wget https://github.com/IntelRealSense/librealsense/archive/v2.29.0.zip
RUN unzip v2.29.0.zip && rm v2.29.0.zip
WORKDIR /Source/librealsense-2.29.0/
RUN mkdir build
WORKDIR /Source/librealsense-2.29.0/build/
RUN cmake ./../ && make && make install 
WORKDIR /Source/librealsense-2.29.0/
RUN cp config/99-realsense-libusb.rules /etc/udev/rules.d/
WORKDIR /Source/
RUN rm -rf ./librealsense-2.29.0/
#########################################################################


# Install Qt5 and openni2
#########################################################################
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y qtcreator \
                       qt5-default \
                       libopenni2-dev && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*
#########################################################################


# Install CloudCompare
#########################################################################
WORKDIR /Source/
RUN wget https://github.com/CloudCompare/CloudCompare/archive/v2.9.1.zip
RUN unzip v2.9.1.zip && rm v2.9.1.zip
RUN mkdir -p /Source/CloudCompare-2.9.1/build
WORKDIR /Source/CloudCompare-2.9.1/build/
RUN cmake .. -DOPTION_BUILD_CCVIEWER=ON \
             -DOPTION_GL_QUAD_BUFFER_SUPPORT=ON \
             -DOPTION_BUILD_PLUGIN=TRUE \
             -DOPTION_GL_QUAD_BUFFER_SUPPORT=ON \
             -DOPTION_USE_DXF_LIB=ON \
             -DOPTION_USE_GDAL=ON \
             -DINSTALL_QPCL_PLUGIN=TRUE \
             -DINSTALL_QANIMATION_PLUGIN=TRUE && \
    make && \
    make install
WORKDIR /Source/
RUN rm -rf ./CloudCompare-2.9.1/
#########################################################################

# Install VSCode
#######################################################################################################################################
RUN apt-get update -y && \
    apt-get install -y apt-transport-https && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
RUN apt-get update -y && \
    apt-get install -y code && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*
#######################################################################################################################################

# Copy bash file
#########################################################################
#COPY start_code.bash /
#########################################################################

WORKDIR /
# replace with other Ubuntu version if desired
# see: https://hub.docker.com/r/nvidia/opengl/
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/lib/x86_64-linux-gnu \
  /usr/local/lib/x86_64-linux-gnu

# replace with other Ubuntu version if desired
# see: https://hub.docker.com/r/nvidia/opengl/
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json

RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    ldconfig && \
    echo '/usr/local/$LIB/libGL.so.1' >> /etc/ld.so.preload && \
    echo '/usr/local/$LIB/libEGL.so.1' >> /etc/ld.so.preload

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
#ENV NVIDIA_DRIVER_CAPABILITIES \
#    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compute,compute32
ENV NVIDIA_DRIVER_CAPABILITIES all


LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda-9.0/bin:/usr/local/cuda/bin:/usr/local/bin:/usr/local/sbin:/user/bin:/sbin:/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda-9.0/lib64:/usr/local/cuda-9.0/lib:/usr/local/cuda/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}


# Set up X window
ENV DISPLAY :0
ENV TERM=xterm
# Some QT-Apps don't not show controls without this
ENV QT_X11_NO_MITSHM 1

WORKDIR /
CMD ["/bin/bash"]
# USER original_user
