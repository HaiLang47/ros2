# Carla PilotNet 端到端控制 ROS 封装（仿真演示）

本模块为离线仿真演示，输入为本地图像，不直接接入 Carla 实时控制流。输出话题需外部节点订阅转换。默认权重为随机初始化。

## 依赖安装
pip install -r requirements.txt

## 编译与运行
mkdir -p ~/carla_pilotnet_ws/src
ln -sfn ~/ros2/src/ground/carla_pilotnet_ros ~/carla_pilotnet_ws/src/carla_pilotnet_ros
cd ~/carla_pilotnet_ws
source /opt/ros/noetic/setup.bash
catkin_make
source devel/setup.bash

conda activate carla38
roslaunch carla_pilotnet_ros main.launch

## 话题验证
- 查看话题：rostopic list | grep carla_pilotnet_ros
- 查看控制量：rostopic echo /carla_pilotnet_ros/pilotnet/control
- 查看图像：rosrun image_view image_view image:=/carla_pilotnet_ros/pilotnet/annotated_image
