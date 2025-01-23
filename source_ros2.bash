#!/bin/bash

ccbs_debug_fn(){
  if [ $# -eq 1 ] 
  then
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo --packages-up-to $1
  else 
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo
  fi
}

colcon_clean_fn(){
  if [ $# -eq 1 ] 
  then
    rm -rf build/$1 install/$1 log
  else 
    rm -rf build install log
  fi
}

# alias colcon_clean="rm -rf build install log"
alias colcon_clean="colcon_clean_fn"
alias ccbs='colcon build --symlink-install --parallel-workers 15'
#alias ccbs_debug='colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo'
alias ccbs_debug='ccbs_debug_fn'
alias ccbs_release='colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release'

alias gdb_ros2_run="ros2 run --prefix 'gdb -ex run --args'"
alias kill_ros_daemon='ros2 daemon stop'
alias kill_ros='sudo pkill -f ros'

source /opt/ros/humble/setup.bash

export ROS_DOMAIN_ID=215
#export ROS_DISCOVERY_SERVER="192.168.1.150:11888"
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI=~/.config/cyclonedds/profile.xml

echo "ROS_DISTRO: $ROS_DISTRO"
echo "ROS_DOMAIN_ID: $ROS_DOMAIN_ID"
echo "ROS_DISCOVERY_SERVER: $ROS_DISCOVERY_SERVER"
echo "RMW_IMPLEMENTATION: $RMW_IMPLEMENTATION"
echo "hostname: $(hostname -I)"
