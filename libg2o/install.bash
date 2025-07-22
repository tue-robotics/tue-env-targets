DIR="/home/${USER}/ros/${ROS_DISTRO}/system/src/g2o/build"
if [ -d "$DIR" ]; then
    :
else
    sudo apt install libeigen3-dev libspdlog-dev libsuitesparse-dev qtdeclarative5-dev qt5-qmake libqglviewer-dev-qt5
    git clone https://github.com/RainerKuemmerle/g2o.git /home/${USER}/ros/${ROS_DISTRO}/system/src/g2o
    cd /home/${USER}/ros/${ROS_DISTRO}/system/src/g2o
    mkdir build
    cd build
    cmake ../
    make
fi