FROM tensorflow/tensorflow:latest-gpu-py3
MAINTAINER tsuyukusa

# apt cahce
# RUN echo 'Acquire::http { Proxy "http://172.17.0.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy \
RUN \
&&  apt update \
&&  apt install -y vim cmake make git libsdl-dev xterm xserver-xorg tightvncserver \
&&  rm -rf /var/lib/apt/lists/* \
&&  pip3 install opencv-python \
&&  cd /notebooks \
&&  git clone https://github.com/miyosuda/async_deep_reinforce.git \
&&  cd /notebooks/async_deep_reinforce \
&&  git clone https://github.com/miyosuda/Arcade-Learning-Environment.git \
&&  cd /notebooks/async_deep_reinforce/Arcade-Learning-Environment \
&&  cmake -DUSE_SDL=ON -DUSE_RLGLUE=OFF -DBUILD_EXAMPLES=OFF . \
&&  make -j 8 \
&&  pip3 install . \
&&  sed -i 's/USE_LSTM = True/USE_LSTM = False/' /notebooks/async_deep_reinforce/constants.py

VOLUME /notebooks
WORKDIR /notebooks