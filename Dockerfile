FROM condaforge/mambaforge
ENV DEBIAN_FRONTEND noninteractive
# RUN apt-get update && apt-get install -y apt-utils ca-certificates locales && rm -rf /var/lib/apt/lists/* \
# 	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
#     && rm -rf /var/lib/apt/lists/*
# ENV LANG en_US.utf8

RUN apt-get update && apt-get install --no-install-recommends -y \
    git wget zsh curl \
    && rm -rf /var/lib/apt/lists/*
RUN mamba create -n ros11 python=3.11 -y

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN cd "$HOME/.oh-my-zsh/custom/plugins/" && git clone https://github.com/zsh-users/zsh-autosuggestions

RUN . "/opt/conda/etc/profile.d/conda.sh" && . "/opt/conda/etc/profile.d/mamba.sh" && mamba activate ros11
RUN mamba install cxx-compiler clang gcc urdfdom poco tinyxml2 make cmake boost eigenpy libopencv gtest -y
RUN mamba install gmock mesalib orocos-kdl pkg-config bullet qt pyqt pyqt5-sip log4cxx gpgme assimp -y
RUN mamba install octomap libspnav mesa-libgl-devel-cos7-x86_64 ogre=1.12.13 pyqt-builder libtheora sdl sdl_image \
pcl yaml-cpp libuvc libjpeg-turbo fcl ompl -y
RUN pip install vcstool empy rospkg numpy ipython cpython defusedxml netifaces
RUN cd $HOME/ && git clone https://github.com/fkie-forks/catkin_tools.git -b py311-asyncio && cd catkin_tools && pip install -e .
