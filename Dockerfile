FROM --platform=linux/amd64 ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools
RUN apt-get install -y libssl-dev libcurl4-openssl-dev liblog4cplus-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-bad gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools
RUN apt-get install -y libx264-dev sudo meson libopus-dev cmake git
RUN git clone --branch feature/vp8_yuv https://github.com/tatsuya-ogawa/agora-gstreamer /opt/agora-gstreamer
RUN cd /opt/agora-gstreamer && ./build_all_3.8.sh
RUN git clone https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp.git /opt/amazon-kinesis-video-streams-producer-sdk-cpp
RUN cd /opt/amazon-kinesis-video-streams-producer-sdk-cpp \
    && mkdir build && cd build \
    && cmake -DBUILD_GSTREAMER_PLUGIN=TRUE .. && make && mv libgstkvssink.so /usr/local/lib/x86_64-linux-gnu/gstreamer-1.0
ENV GST_PLUGIN_PATH=/usr/local/lib/x86_64-linux-gnu/gstreamer-1.0
ENV LD_LIBRARY_PATH=/opt/amazon-kinesis-video-streams-producer-sdk-cpp/build/open-source/local/lib
