FROM ubuntu:20.04

# tzdata since 2018 need set noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"
ENV PATH "$PATH:/home/developer/flutter/bin"

# Prerequisites
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget sudo \
    && yes | apt-get install vim \
    # install ruby needs libraries
    && yes | sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev \
    # install ruby    
    && sudo yes | apt-get install ruby ruby-dev \
    && sudo gem install fastlane -NV \
    && sudo apt-get install -y libc6-dev g++ \
    # Set up new user
    && useradd -ms /bin/bash developer

USER developer
WORKDIR /home/developer

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk \ 
    && mkdir -p .android && touch .android/repositories.cfg \
    && mkdir workspace \
    # Set up Android SDK
    && wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip \
    && unzip sdk-tools.zip && rm sdk-tools.zip \
    && mv tools Android/sdk/tools \
    && cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses \
    && cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29" \
    # Download Flutter SDK
    && git clone https://github.com/flutter/flutter.git \
    # Run basic check to download Dark SDK
    && flutter channel dev \
    && flutter upgrade \
    && flutter doctor