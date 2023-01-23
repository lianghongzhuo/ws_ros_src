FROM condaforge/mambaforge
ENV DEBIAN_FRONTEND noninteractive
# RUN apt-get update && apt-get install -y apt-utils ca-certificates locales && rm -rf /var/lib/apt/lists/* \
# 	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
#     && rm -rf /var/lib/apt/lists/*
# ENV LANG en_US.utf8

RUN apt-get update && apt-get install --no-install-recommends \
    git wget zsh curl -y \
    && rm -rf /var/lib/apt/lists/*

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN cd "$HOME/.oh-my-zsh/custom/plugins/" && git clone https://github.com/zsh-users/zsh-autosuggestions
RUN mamba create -n ros11 python=3.11 -y
RUN . "/opt/conda/etc/profile.d/conda.sh" && . "/opt/conda/etc/profile.d/mamba.sh" && mamba activate ros11 \
&& mamba install cxx-compiler clang gcc urdfdom poco tinyxml2 make cmake boost eigenpy libopencv gtest \
gmock mesalib orocos-kdl pkg-config bullet qt pyqt pyqt5-sip log4cxx gpgme assimp \
octomap libspnav mesa-libgl-devel-cos7-x86_64 ogre=1.12.13 pyqt-builder libtheora sdl sdl_image \
pcl yaml-cpp libuvc libjpeg-turbo fcl ompl numpy ipython -y
RUN . "/opt/conda/etc/profile.d/conda.sh" && . "/opt/conda/etc/profile.d/mamba.sh" && mamba activate ros11 \
&& pip install vcstool empy rospkg defusedxml netifaces cpython \
&& cd $HOME/ && git clone https://github.com/fkie-forks/catkin_tools.git -b py311-asyncio && cd catkin_tools \
&& pip install -e .
COPY core.repos /root/ws_ros/
RUN . "/opt/conda/etc/profile.d/conda.sh" && . "/opt/conda/etc/profile.d/mamba.sh" && mamba activate ros11 \
&& cd /root/ws_ros/ && mkdir -p /root/ws_ros/src && cd /root/ws_ros/ && vcs import --input core.repos /root/ws_ros/src \
&& catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -Wno-dev -DCATKIN_ENABLE_TESTING=OFF
RUN . "/opt/conda/etc/profile.d/conda.sh" && . "/opt/conda/etc/profile.d/mamba.sh" && mamba activate ros11 \
&& export ROS_VERSION=1 && export ROS_DISTRO=one \
&& cd /root/ws_ros/ && catkin build
