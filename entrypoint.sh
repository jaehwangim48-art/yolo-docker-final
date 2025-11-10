#!/bin/bash
# 이미지 URL을 첫 번째 인자로 받음
IMAGE_URL=$1

if [ -z "$IMAGE_URL" ]; then
    echo "Usage: docker run YOUR_DOCKER_ID/yolo <IMAGE_URL>"
    exit 1
fi

# 이미지 다운로드
wget -O input.jpg "$IMAGE_URL"

# Darknet YOLOv3 객체 검출 실행 (텍스트 결과만 출력)
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg -thresh 0.5 -dont_show