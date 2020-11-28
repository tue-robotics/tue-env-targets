#! /usr/bin/env bash
set -e

function echo_and_run() { echo "$@" ; "$@" ; }

function symlink() { if [ ! -h "$2" ] ; then sudo ln -fsv "$@"; fi; }

if dpkg-query -l opencv* libopencv* > /dev/null 2>&1
then
    echo_and_run sudo apt purge opencv* libopencv* # Explicitly ask for confirmation
fi

irohms-install-system-now ros-"$TUE_ROS_DISTRO"-opencv3 libopenblas-dev libgoogle-glog-dev \
    protobuf-compiler libatlas-base-dev

symlink /opt/ros/"$TUE_ROS_DISTRO"/lib/x86_64-linux-gnu/libopencv_core3.so /usr/lib/libopencv_core.so
symlink /opt/ros/"$TUE_ROS_DISTRO"/lib/x86_64-linux-gnu/libopencv_highgui3.so /usr/lib/libopencv_highgui.so
symlink /opt/ros/"$TUE_ROS_DISTRO"/lib/x86_64-linux-gnu/libopencv_imgcodecs3.so /usr/lib/libopencv_imgcodecs.so
symlink /opt/ros/"$TUE_ROS_DISTRO"/lib/x86_64-linux-gnu/libopencv_imgproc3.so /usr/lib/libopencv_imgproc.so
symlink /opt/ros/"$TUE_ROS_DISTRO"/lib/x86_64-linux-gnu/libopencv_videoio3.so /usr/lib/libopencv_videoio.so
symlink /opt/ros/"$TUE_ROS_DISTRO"/include/opencv-3.3.1-dev/opencv2 /usr/include/opencv2

if cd ~/openpose
then
    git pull
else
    git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose ~/openpose
fi

pip2 install --user numpy
pip2 install --user protobuf

if [ ! -d ~/openpose/build ]
then
    echo "

    Great, now run these four commands yourself:
    cd ~/openpose
    bash ./ubuntu/install_caffe_and_openpose_if_cuda8.sh
    roscd image_recognition_openpose
    ln -s ~/openpose

    "

    if [ "$DOCKER" == "true" ]
    then
        mkdir -p ~/openpose/build
        cd ~/openpose/build
        cmake -DBUILD_PYTHON=ON .. || irohms-install-error "CMake configuration error"
        make -j "$(nproc)" || irohms-install-error "Build error"
        roscd image_recognition_openpose
        ln -s ~/openpose .
    fi
fi

set +e
