DIR="/home/${USER}/ros/${ROS_DISTRO}/system/src/unitree_legged_sdk/build"
if [ -d "$DIR" ]; then
    :
else
    git clone https://github.com/CardiffUniversityComputationalRobotics/unitree_legged_sdk.git /home/${USER}/ros/${ROS_DISTRO}/system/src/unitree_legged_sdk
    cd /home/${USER}/ros/${ROS_DISTRO}/system/src/unitree_legged_sdk
    git checkout v3.3.2
    mkdir build
    cd build
    cmake ../
    make
fi