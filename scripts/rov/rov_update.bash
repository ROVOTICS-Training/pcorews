#!/bin/bash

# Check sudo perms
# if [[ "$(id -u)" != 0 ]]
#   then echo "Please run as root"
#   exit
# fi

# Update the corews
git pull --hard

USER_NAME="$USER"
# Remove previously compiled code
rm -rf ~/corews/build
rm -rf ~/corews/install
rm -rf ~/corews/log

cd ~/corews/src

# Remove old packages
rm -rf thruster_interface gpio_interface sensor_interface

# Clone new packages
git clone https://github.com/JHSRobo/thruster_interface
git clone https://github.com/JHSRobo/gpio_interface
git clone https://github.com/JHSRobo/sensor_interface

current_path=$(pwd)

# Update dependencies
sudo -u jhsrobo rosdep update
sudo -u jhsrobo rosdep install --from-paths $current_path --ignore-src --rosdistro=${ROS_DISTRO} -y --os=ubuntu:jammy

# Install Packages that are NOT RECOGNIZED BY ROSDEP
# You can find lists of all rosdep recognized packages here:
# https://github.com/ros/rosdistro/tree/master/rosdep
# If your package isn't in base.yaml or python.yaml, add it below.
pip install adafruit-circuitpython-bme280 adafruit-circuitpython-sht31d adafruit-circuitpython-ahtx0 ninja meson smbus2 adafruit_bno055 RPi.GPIO

cd ~
colcon build --symlink-install

echo "Remember to source ~/.bashrc and compile!"