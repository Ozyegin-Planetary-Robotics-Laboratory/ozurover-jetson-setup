#!/bin/bash
echo "OzURover Setup Script"

if [ "$EUID" -ne 0 ]
  then echo "Must run as root"
  exit
fi

# Update repositories
echo "Updating repositories..."
sudo apt-get update

# Pre-installation
echo "Installing pre-requisites..."
sudo alias apt-get="apt-get --assume-yes"
sudo alias apt="apt --assume-yes"
sudo apt install git
sudo apt install vim
sudo apt install curl
mkdir ~/scripts

# Add repository
echo "Adding ROS repository..."
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt --assume-yes update

# Install ROS
echo "Installing ROS..."
sudo apt --assume-yes install ros-melodic-desktop-full

# Environment setup
echo "Setting up environment..."
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
# shellcheck disable=SC1090
source ~/.bashrc
source /opt/ros/melodic/setup.bash

# Dependencies for building packages
echo "Installing dependencies..."
sudo apt --assume-yes install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential

# Initialize rosdep
echo "Initializing rosdep..."
sudo apt --assume-yes install python-rosdep
sudo rosdep init
sudo rosdep fix-permissions
rosdep update

# Create workspace
echo "Creating workspace..."
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/ || exit
catkin_make
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

# Install dependencies
echo "Installing dependencies..."
sudo apt --assume-yes install ros-melodic-joy ros-melodic-teleop-twist-joy ros-melodic-teleop-twist-keyboard \
  ros-melodic-laser-proc ros-melodic-rgbd-launch ros-melodic-depthimage-to-laserscan \
  ros-melodic-rosserial-arduino ros-melodic-rosserial-python ros-melodic-rosserial-server \
  ros-melodic-rosserial-client ros-melodic-rosserial-msgs ros-melodic-amcl ros-melodic-map-server \
  ros-melodic-move-base ros-melodic-urdf ros-melodic-xacro ros-melodic-compressed-image-transport \
  ros-melodic-rqt-image-view ros-melodic-gmapping ros-melodic-navigation ros-melodic-interactive-markers

echo "Installing ROS...DONE"

# Update and upgrade
echo "Updating repositories and upgrading packages..."
sudo apt-get --assume-yes update
sudo apt-get --assume-yes upgrade

# Install Python Venv and PIP
echo "Installing Python VEnv and PIP..."
sudo apt --assume-yes install python3-venv python3-pip

# Install OpenCV Dependencies
echo "Installing OpenCV Dependencies..."
sudo apt-get --assume-yes install build-essential cmake unzip pkg-config
sudo apt-get --assume-yes install libjpeg-dev libpng-dev libtiff-dev
sudo pip3 install scikit-build

# Install OpenCV
echo "Installing OpenCV..."
sudo apt-get --assume-yes install libopencv-dev

# Install OpenCV Python Package
echo "Installing OpenCV Python Package..."
sudo pip3 install opencv-python==4.6.0.66

# Install OpenCV Python Contrib Package
echo "Installing OpenCV Python Contrib Package..."
sudo pip3 install opencv-contrib-python==4.6.0.66
echo "Installing OpenCV...DONE"

# Install ZED SDK
echo "Installing ZED SDK..."
https://download.stereolabs.com/zedsdk/4.0/l4t32.7/jetsons
cd ~/scripts || exit
curl -o zedsdk.zstd.run https://download.stereolabs.com/zedsdk/4.0/l4t32.7/jetsons
chmod +x zedsdk.zstd.run
sudo ./zedsdk.zstd.run

# Install ZED Python Package
echo "Installing ZED Python Package..."
sudo pip3 install pyzed

# Clone Zed Ros Wrapper
echo "Cloning Zed ROS Wrapper..."
cd ~/catkin_ws/src || exit
git --recurse-submodules https://github.com/stereolabs/zed-ros-wrapper.git
cd ..
catkin_make
rosdep update