# ROS from Source in Conda Environment
```bash
sudo apt install libpoco-dev
sudo apt install libfltk1.3-dev
sudo apt install libgpgme-dev gnupg2
sudo apt install libspnav-dev
sudo apt install libqt5websockets5-dev libqt5x11extras5-dev
sudo apt install libsdl1.2-dev libsdl-image1.2-dev
sudo apt install libuvc-dev
sudo apt install libunwind-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

```

```bash
mamba create -n ros11 python=3.11
mamba activate ros11
pip install vcstool empy rospkg numpy ipython cpython defusedxml netifaces
vcs import --input core.repos ./src
cd upstream && git clone https://github.com/fkie-forks/catkin_tools.git -b py311-asyncio && cd catkin_tools && pip install -e  &&cd ../..
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -Wno-dev
./ignore.sh
unset ROS_DISTRO
catkin build --continue-on-failure
```
