DIR="/home/${USER}/ros/${ROS_DISTRO}/system/src/abseil-cpp"
if [ -d "$DIR" ]; then
 :
else
  set -o errexit
  set -o verbose

  git clone https://github.com/abseil/abseil-cpp.git
  cd abseil-cpp
  git checkout 215105818dfde3174fe799600bb0f3cae233d0bf # 20211102.0
  mkdir build
  cd build
  cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DCMAKE_INSTALL_PREFIX=/usr/local/stow/absl \
    ..
  ninja
  sudo ninja install
  cd /usr/local/stow
  sudo stow absl
fi