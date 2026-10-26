# ROS Noetic 与 Conda 环境共存排错指南

在 OpenHUTB 项目中，由于深度学习依赖（PyTorch、Ultralytics）通常安装在 Conda 虚拟环境中，而 ROS Noetic 默认依赖系统的 Python 3.8。两者混合使用时极易出现各种环境报错。本文档总结了常见的排错方案。

## 1. import rospy 报错 ModuleNotFoundError: No module named 'yaml' / 'rospkg'

**原因**：Conda 环境相对独立，没有继承系统 ROS 的基础包。
**解决**：在 Conda 环境中补齐 ROS 的 Python 依赖：

    pip install pyyaml rospkg catkin_pkg empy -i https://mirrors.aliyun.com/pypi/simple/

## 2. cv_bridge 与 Conda 环境中的 OpenCV 冲突

**原因**：ROS 自带的 cv_bridge 是基于系统 OpenCV（如 4.2）编译的。如果在 Conda 环境里装了更高版本的 OpenCV（如 4.9 或 5.0），调用 cv_bridge 时会报 KeyError 或 Segmentation fault。
**解决**：有两种方案。

- **方案 A（推荐）**：在 ROS 节点代码中绕过 cv_bridge，手动构造和解析 sensor_msgs/Image 消息。
- **方案 B**：强制降级 Conda 环境的 OpenCV 版本，使其与系统版本一致。

## 3. roslaunch 找不到节点或报 RLException

**原因**：新开终端没有 source 工作空间的 devel/setup.bash，或者 python 解释器找不到。
**解决**：
在使用 roslaunch 或 rosrun 之前，确保：

    source /opt/ros/noetic/setup.bash
    source ~/carla_xxx_ws/devel/setup.bash

## 4. import torch 或 import ultralytics 失败

**原因**：直接 roslaunch 时调用的是系统 Python 3.8，而依赖装在 Conda 中。
**解决**：在 launch 文件启动前，通过脚本先激活 Conda 环境，或者显式指定使用 Conda 的 Python 路径：

    export PYTHONPATH=/home/user/miniconda3/envs/carla38/lib/python3.8/site-packages:$PYTHONPATH

或者编写 main.sh，里面加入 conda activate carla38。

## 5. Linux 下 Carla 客户端报 undefined symbol

**原因**：Conda 环境中的 libc++ 与 Carla whl 不兼容。
**解决**：在运行节点前设置 LD_PRELOAD：

    export LD_PRELOAD=$CONDA_PREFIX/lib/libc++.so.1:$CONDA_PREFIX/lib/libc++abi.so.1
