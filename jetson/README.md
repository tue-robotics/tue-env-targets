installing firmware on Jetson with Orbitty Carrier:
* download the manual: http://www.connecttech.com/pdf/CTIM-ASG003_Manual.pdf
* download and install JetPack 3.2.0 on desktop pc:
	* download https://developer.nvidia.com/embedded/jetpack
	* follow steps on https://docs.nvidia.com/jetpack-l4t/index.html#developertools/mobile/jetpack/l4t/3.2/install.htm
* download and install L4T Board Support Packages
	* Download L4T R28.2
    http://www.connecttech.com/ftp/Drivers/CTI-L4T-V115.tgz
	* Follow steps on CTI-L4T BSPs for TX2 and TX2i [L4T V28.2 and Higher](CTI-L4T-V1XX)
    http://connecttech.com/resource-center/cti-l4t-nvidia-jetson-board-support-package-release-notes/


login with ubuntu user:

```
sudo adduser --disabled-password --gecos "" amigo
sudo adduser amigo 
sudo usermod -a -G adm,dialout,sudo,audio,video amigo
sudo passwd amigo
echo '%sudo ALL=(ALL) NOPASSWD:ALL' | sudo tee --append /etc/sudoers
sudo reboot
```

login with amigo user:

```
ssh-keygen
source <(wget -O- https://raw.githubusercontent.com/tue-robotics/tue-env/master/installer/scripts/bootstrap-ros-kinetic)
tue-get install ros
tue-get install openpose
tue-get install ros-openpose_ros
tue-make
source ~/.bashrc
roscd openpose_ros
ln -s ~/openpose 
tue-make --pre-clean openpose_ros
```

test with:

```
export ROS_MASTER_URI=http://athome8.local:11311
rosrun openpose_ros openpose_ros_node _net_input_width:=368 _net_input_height:=368 _net_output_width:=368 _net_output_height:=368 _model_folder:=/home/amigo/openpose/models/ __ns:=amigo/pose_detector
```

Make sure the hosts can be found ping from amigo1 to jetson and from jetson to amigo1 should work based on hostnames, not IP

optionally: install service:

```
sudo install /home/amigo/.tue/installer/targets/ros-openpose_ros/openpose_ros.service /etc/systemd/system/
sudo systemctl enable openpose_ros
sudo systemctl start openpose_ros
```

For use on amigo:
```
tue-get install amigo4
```
