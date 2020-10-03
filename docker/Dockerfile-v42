FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apt-utils \
    bison \
    ca-certificates \
    ccache \
    check \
    cmake \
    curl \
    flex \
    git \
    gperf \
    lcov \
    libncurses-dev \
    libusb-1.0-0-dev \
    locales \
    make \
    nano \
    ninja-build \
    python3 \
    python3-pip \
    rsync \
    unzip \
    vim \
    wget \
    xz-utils \
    zip \
   && apt-get autoremove -y \
   && rm -rf /var/lib/apt/lists/* \
   && update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN python -m pip install --upgrade pip virtualenv

COPY shallow_clone /usr/bin/ 
ENV IDF_TOOLS_PATH=/opt/esp
ENV IDF_PATH=/opt/esp/idf
ENV LIB_BUILDER_PATH=/opt/esp/lib-builder
ENV NO_GIT=1

RUN shallow_clone https://github.com/espressif/esp-idf release/v4.2 $IDF_PATH \
    && cd $IDF_PATH && git submodule update --progress --depth 1 --init --recursive \
    && rm $IDF_PATH/components/expat/expat/testdata/largefiles/* \
    && if [ $NO_GIT ]; then find $IDF_PATH/.git -delete; fi

RUN sed -i "s/'--no-site-packages',//" $IDF_PATH/tools/idf_tools.py \
    && $IDF_PATH/install.sh \
    && rm /opt/esp/dist/*

RUN shallow_clone https://github.com/espressif/esp32-arduino-lib-builder master $LIB_BUILDER_PATH \
    && if [ $NO_GIT ]; then find $LIB_BUILDER_PATH/.git -delete; fi

RUN shallow_clone https://github.com/espressif/arduino-esp32 esp32s2 $LIB_BUILDER_PATH/components/arduino \
    && mv $LIB_BUILDER_PATH/components/arduino/tools/sdk/esp32/sdkconfig $LIB_BUILDER_PATH/sdkconfig.esp32 \
    && mv $LIB_BUILDER_PATH/components/arduino/tools/sdk/esp32s2/sdkconfig $LIB_BUILDER_PATH/sdkconfig.esp32s2 \
    && rm -rf $LIB_BUILDER_PATH/components/arduino/tools/sdk \
    && if [ $NO_GIT ]; then find $LIB_BUILDER_PATH/components/arduino/.git -delete; fi

RUN shallow_clone https://github.com/espressif/esp32-camera/ master $LIB_BUILDER_PATH/components/esp32-camera \
    && if [ $NO_GIT ]; then find $LIB_BUILDER_PATH/components/esp32-camera/.git -delete; fi
RUN shallow_clone https://github.com/espressif/esp-face/ master $LIB_BUILDER_PATH/components/esp-face \
    && if [ $NO_GIT ]; then find $LIB_BUILDER_PATH/components/esp-face/.git -delete; fi

RUN echo "PATH=$IDF_TOOLS_PATH/xtensa-esp32-elf/bin:$PATH\n \
         cd $LIB_BUILDER_PATH\n \
         source $IDF_PATH/export.sh &> /dev/null" >> /root/.bashrc

# All the little fixes
COPY build.sh $LIB_BUILDER_PATH
COPY prepare-libs.sh $LIB_BUILDER_PATH/tools
RUN sed -i 's|sdk"|sdk/$PRODUCT"|' $LIB_BUILDER_PATH/tools/config.sh \
    && sed -i "/setup()/d ; /loop()/d" $LIB_BUILDER_PATH/components/arduino/cores/esp32/main.cpp \
    && sed 's/blink/arduino/' $IDF_PATH/examples/get-started/blink/CMakeLists.txt > $LIB_BUILDER_PATH/CMakeLists.txt \
    && sed 's/blink.c/sketch.cpp/' $IDF_PATH/examples/get-started/blink/main/CMakeLists.txt > $LIB_BUILDER_PATH/main/CMakeLists.txt \
    && sed -i 's/rtc_gpio_desc/rtc_io_desc/g' $LIB_BUILDER_PATH/components/esp32-camera/driver/twi.c
