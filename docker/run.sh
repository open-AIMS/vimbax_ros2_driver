#!/bin/bash
source /opt/ros/humble/setup.bash
source /root/ros2_ws/install/local_setup.bash
source /root/ros2_ws/install/setup.bash
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
source /etc/profile.d/VimbaX_GenTL_Path_64bit.sh
ros2 run vimbax_camera vimbax_camera_node

