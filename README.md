# ROS from Source in Conda Environment
```bash
sudo apt install libpoco-dev libfltk1.3-dev libgpgme-dev gnupg2 libspnav-dev libtinyxml2-dev libassimp-dev \
libqt5websockets5-dev libqt5x11extras5-dev libsdl1.2-dev libsdl-image1.2-dev libcap-dev libyaml-dev libyaml-cpp-dev \
libuvc-dev libconsole-bridge-dev liburdfdom-dev liborocos-kdl-dev libgtest-dev bzip2 libbz2-dev libqt5svg5-dev \
libunwind-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libbullet-dev coreutils libopencv-dev \
libturbojpeg0-dev libcv-bridge-dev libimage-transport-dev liboctomap-dev libogre-1.9-dev
```

for moveit
```bash
sudo apt install libfcl-dev
```

```bash
mamba create -n ros11 python=3.11
mamba activate ros11
pip install vcstool empy rospkg numpy ipython cpython defusedxml netifaces PyQt5 PyQt-builder
mkdir upstream src && vcs import --input core.repos ./src
cd upstream && git clone https://github.com/fkie-forks/catkin_tools.git -b py311-asyncio && cd catkin_tools && pip install -e . && cd ../..
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -Wno-dev
unset ROS_DISTRO
catkin build --continue-on-failure
```
