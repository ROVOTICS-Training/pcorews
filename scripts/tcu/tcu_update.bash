#!/bin/bash

# Check sudo perms
# if [[ "$(id -u)" != 0 ]]
#   then echo "Please run as root"
#   exit
# fi
USER_NAME="$USER"
# Update the corews
git pull --hard

# Remove previously compiled code
rm -rf ~/corews/build
rm -rf ~/corews/install
rm -rf ~/corews/log

cd ~/corews/src
# Remove old packages
rm -rf core motion_control rov_sim pilot_gui gripper_control

# Clone new packages
git clone https://github.com/JHSRobo/core
git clone https://github.com/JHSRobo/motion_control
git clone https://github.com/JHSRobo/gripper_control
git clone https://github.com/JHSRobo/pilot_gui

current_path=$(pwd)

# Update dependencies
sudo -u $USER_NAME rosdep install --from-paths $current_path --ignore-src --rosdistro=${ROS_DISTRO} -y --os=ubuntu:jammy

# Give jhsrobo ownership of the workspace
sudo chown $USER_NAME: -R /home/$USER_NAME/corews

# Install phidget packages
sudo curl -fsSL https://www.phidgets.com/downloads/setup.linux | bash
sudo apt install -y libphidget22
sudo pip install Phidget22

echo "Remember to source ~/.bashrc and compile!"

