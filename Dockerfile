FROM ubuntu:jammy-20221130

ARG MINIFORGE_NAME=Mambaforge
ARG MINIFORGE_VERSION=22.9.0-3
ARG TARGETPLATFORM

ENV CONDA_DIR=/opt/conda
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=${CONDA_DIR}/bin:${PATH}
SHELL ["/bin/bash", "-c"]

# copy from
# https://github.com/conda-forge/miniforge-images/blob/master/ubuntu/Dockerfile
# to get latest version of ubuntu
# 1. Install just enough for conda to work
# 2. Keep $HOME clean (no .wget-hsts file), since HSTS isn't useful in this context
# 3. Install miniforge from GitHub releases
# 4. Apply some cleanup tips from https://jcrist.github.io/conda-docker-tips.html
#    Particularly, we remove pyc and a files. The default install has no js, we can skip that
# 5. Activate base by default when running as any *non-root* user as well
#    Good security practice requires running most workloads as non-root
#    This makes sure any non-root users created also have base activated
#    for their interactive shells.
# 6. Activate base by default when running as root as well
#    The root user is already created, so won't pick up changes to /etc/skel
RUN apt-get update > /dev/null && \
    apt-get install --no-install-recommends --yes \
        wget bzip2 ca-certificates \
        git \
        tini \
        > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget --no-hsts --quiet https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-$(uname -m).sh -O /tmp/miniforge.sh && \
    /bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniforge.sh && \
    conda clean --tarballs --index-cache --packages --yes && \
    find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
    find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
    conda clean --force-pkgs-dirs --all --yes  && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> /etc/skel/.bashrc && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> ~/.bashrc

# ENV DEBIAN_FRONTEND noninteractive

RUN mamba create -n ros11 python=3.11 -y
RUN . "${CONDA_DIR}/etc/profile.d/conda.sh" && . "${CONDA_DIR}/etc/profile.d/mamba.sh" && mamba activate ros11 \
&& mamba install cxx-compiler clang gcc urdfdom poco tinyxml2 make cmake boost eigenpy libopencv gtest \
gmock mesalib orocos-kdl pkg-config bullet qt pyqt pyqt5-sip log4cxx gpgme assimp \
octomap libspnav mesa-libgl-devel-cos7-x86_64 pyqt-builder libtheora sdl sdl_image \
pcl yaml-cpp libuvc libjpeg-turbo fcl ompl numpy ipython gazebo -y && mamba clean --all -y
RUN . "${CONDA_DIR}/etc/profile.d/conda.sh" && . "${CONDA_DIR}/etc/profile.d/mamba.sh" && mamba activate ros11 \
&& pip install vcstool empy rospkg defusedxml netifaces cpython \
&& cd $HOME/ && git clone https://github.com/fkie-forks/catkin_tools.git -b py311-asyncio && cd catkin_tools \
&& pip install -e .
COPY core.repos /root/ws_ros/
RUN . "${CONDA_DIR}/etc/profile.d/conda.sh" && . "${CONDA_DIR}/etc/profile.d/mamba.sh" && mamba activate ros11 \
&& cd /root/ws_ros/ && mkdir -p /root/ws_ros/src && cd /root/ws_ros/ && vcs import --input core.repos /root/ws_ros/src \
&& catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -Wno-dev -DCATKIN_ENABLE_TESTING=OFF
RUN . "${CONDA_DIR}/etc/profile.d/conda.sh" && . "${CONDA_DIR}/etc/profile.d/mamba.sh" && mamba activate ros11 \
&& export ROS_VERSION=1 && export ROS_DISTRO=one \
&& cd /root/ws_ros/ && catkin build
