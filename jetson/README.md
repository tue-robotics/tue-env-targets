installing firmware on Jetson with Orbitty Carrier:
* download the manual: http://www.connecttech.com/pdf/CTIM-ASG003_Manual.pdf
* download and install JetPack 3.1.0 on desktop pc (we do require CUDA 8):
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

First fix the CA cerfiticates:
```
sudo apt-get install ca-cacert
sudo c_rehash /etc/ssl/certs
sudo update-ca-certificates
```

```
ssh-keygen
source <(wget -O- https://raw.githubusercontent.com/cucr-robotics/cucr-env/master/installer/bootstrap.bash)
cucr-get install ros
cucr-get install openpose
cucr-get install ros-image_recognition_openpose
cucr-make
source ~/.bashrc
roscd image_recognition_openpose
ln -s ~/openpose
cucr-make --pre-clean image_recognition_openpose
```

test with:

```
export ROS_MASTER_URI=http://<hostname>.local:11311
rosrun image_recognition_openpose image_recognition_openpose_node _net_input_width:=368 _net_input_height:=368 _net_output_width:=368 _net_output_height:=368 _model_folder:=/home/amigo/openpose/models/ __ns:=amigo/pose_detector
```

Make sure the hosts can be found ping from amigo1 to jetson and from jetson to amigo1 should work based on hostnames, not IP

optionally: install service:

```
sudo install $CUCR_ENV_TARGETS_DIR/ros-image_recognition_openpose/image_recognition_openpose.service /etc/systemd/system/
sudo systemctl enable image_recognition_openpose
sudo systemctl start image_recognition_openpose
```

For use on amigo:
```
cucr-get install amigo4
```
