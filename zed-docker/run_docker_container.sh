#!/bin/bash

# 参考
# ネットワークをホストOSマシンと統一する
# https://qiita.com/zembutsu/items/9e9d80e05e36e882caaa
# ndidia-driverを使用したubuntu16.04のホストマシンにおいて
# コンテナ内でOpenGLを使用する設定
# https://tail-island.github.io/programming/2017/07/11/docker-for-development-container-on-linux.html
# https://qiita.com/eisoku9618/items/c2cca0f0bf764def2efd
# https://github.com/NVIDIA/nvidia-docker/issues/534


# 使用するイメージの設定
IMAGE_NAME=$1
if [[ -z "${IMAGE_NAME}" ]]; then
    IMAGE_NAME=zed_velo:latest
fi

# コンテナ名の設定
CONTAINER_NAME=$2
if [[ -z "${CONTAINER_NAME}" ]]; then
    CONTAINER_NAME=zed_velo
fi

# マウントするホストOSのボリュームPATHを設定
HOST_DIR=$3
if [[ -z "${HOST_DIR}" ]]; then
    HOST_DIR=/mnt/container-data/
fi

# マウントするコンテナのボリュームPATHを設定
CONTAINER_DIR=$4
if [[ -z "${CONTAINER_DIR}" ]]; then
    CONTAINER_DIR=/datas/
fi

echo "Image name         : ${IMAGE_NAME}"
echo "Container name     : ${CONTAINER_NAME}"
echo "Host directory     : ${HOST_DIR}"
echo "Container directory: ${CONTAINER_DIR}"

# dockerのコンテナを探すコマンドでコンテナの存在を確認する
DOPE_ID=`docker ps -aqf "name=^/${CONTAINER_NAME}$"`

if [ -z "${DOPE_ID}" ]; then
    echo "Creating new DOPE docker container."
    xhost +local:root
    docker run --runtime=nvidia -it --privileged --net host -v ${HOST_DIR}:${CONTAINER_DIR}:rw -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v ~/.Xauthority:/root/.Xauthority:rw --env="DISPLAY=${DISPLAY}" --env="QT_X11_NO_MITSHM=1"  --env="XAUTHORITY=$XAUTH" --name=${CONTAINER_NAME} ${IMAGE_NAME} /bin/bash

else
    echo "Found DOPE docker container: ${DOPE_ID}."
    # Check if the container is already running and start if necessary.
    if [ -z `docker ps -qf "name=^/${CONTAINER_NAME}$"` ]; then
        xhost +local:${DOPE_ID}
        echo "Starting and attaching to ${CONTAINER_NAME} container..."
        docker start ${DOPE_ID}
        docker attach ${DOPE_ID}
    else
        echo "Found running ${CONTAINER_NAME} container, attaching bash..."
        docker exec -it ${DOPE_ID} bash
    fi
fi
