# ROS from Source in Conda Environment

```bash
mamba create -n ros11 python=3.11
mamba activate ros11
mkdir src && vcs import --input core.repos ./src
pip install git+https://github.com/catkin/catkin_tools
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-deprecated -Wno-dev -DCATKIN_ENABLE_TESTING=OFF
export ROS_VERSION=1 && export ROS_DISTRO=one
catkin build --continue-on-failure
```

## update repo
`vcs export src > core.repos`

## build docker image
`docker image build -t ros_docker .`

## create docker container
`docker run -i -d --name ros11 --privileged --net=host ros_docker`

`docker exec -it ros11 bash`
