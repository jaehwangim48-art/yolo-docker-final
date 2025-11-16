# Darknet 컴파일에 필요한 기본 환경 (Ubuntu 18.04 기반)
FROM ubuntu:18.04
# 시간대 설정 질문을 건너뛰도록 설정
ENV DEBIAN_FRONTEND=noninteractive
# 환경 업데이트 및 빌드 도구 설치
# libopencv-dev 패키지 제거
RUN apt-get update && \
    apt-get install -y git build-essential wget python3 && \
    rm -rf /var/lib/apt/lists/*

# Darknet 소스 코드 다운로드 및 컴파일 준비
RUN git clone https://github.com/pjreddie/darknet /usr/src/darknet
WORKDIR /usr/src/darknet

# Darknet Makefile 수정 (CPU 환경, OPENCV 사용 '비활성화')
# OPENCV=0 으로 설정하여 OpenCV를 사용하지 않도록 강제
RUN sed -i 's/GPU=0/GPU=0/' Makefile && \
    sed -i 's/OPENCV=1/OPENCV=0/' Makefile && \
    sed -i 's/CUDNN=0/CUDNN=0/' Makefile

# Darknet 컴파일
RUN make

# YOLOv3 사전 학습된 가중치 파일 다운로드
RUN wget https://data.pjreddie.com/files/yolov3.weights

# 실행 스크립트 작성 및 권한 부여
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 컨테이너 실행 설정
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD [""]