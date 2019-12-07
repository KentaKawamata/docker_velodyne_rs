# Use Velodyne and RealSense in Docker

[dockerhub](https://hub.docker.com/r/reizouko/use-velodyne-rs)  
[github](https://github.com/KentaKawamata/docker_velodyne_rs)

### コンテナOS
Ubuntu 16.04

### インストール済み

- CUDA 9.0
- cudnn 7
- ROS kinetic
- PCL 1.7.1
- librealsense-2.25.0
- CloudCompare-2.9.1
- ros-kinetic-velodyne
- realsense-ros
- VSCode

### 動作確認環境
|||
|:--:|:--:|
|Host OS| Ubuntu 16.04|
|kernel|4.15.0|
|Docker|18.09.7|
|nVIDIA Driver| 396.54|
|CUDA|9.2.148|

|||
|:--:|:--:|
|Host OS| Ubuntu 18.04|
|kernel|4.15.0|
|Docker|19.03.4|
|nVIDIA Driver| 430.26|
|CUDA|10.2|


### コンテナ起動後の設定

```
# apt-get update
# upt-get upgrade
# rosdep update
# cd /catkin_es/src
# rosdep install -r -y --from-paths . --ignore-src
```