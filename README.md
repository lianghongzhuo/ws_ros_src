# ROS from Source in Conda Environment

```bash
mamba create -n ros11 python=3.11
mamba activate ros11
mkdir upstream src && vcs import --input core.repos ./src
cd upstream && git clone https://github.com/fkie-forks/catkin_tools.git -b py311-asyncio && cd catkin_tools && pip install -e . && cd ../..
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -Wno-dev -DCATKIN_ENABLE_TESTING=OFF
export ROS_VERSION=1 && export ROS_DISTRO=one
catkin build --continue-on-failure
```

## update repo
`vcs export src > core.repos`

## build docker image
`docker image build -t ros_docker .`

## create docker container
`docker run -i -d --name ros11 -v $HOME/code/ws_ros_src/:/root/code/ws_ros_src --privileged --net=host ros_docker`

`docker exec -it ros11 bash`
