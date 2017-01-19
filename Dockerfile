#
# Dockerfile for YachtsServer swift serverside
#

#FROM ubuntu:15.10
FROM ubuntu:16.04
MAINTAINER Matt Schmulen "matt.schmulen@gmail.com"

ENV SWIFT_VERSION 3.0.2-RELEASE
ENV SWIFT_PLATFORM ubuntu16.04
ENV SWIFT_INSTALL_URL https://swift.org/builds/swift-3.0.2-release/ubuntu1604/swift-3.0.2-RELEASE/swift-3.0.2-RELEASE-ubuntu16.04.tar.gz

#RUN echo "Install apt-get Dependencies"
# note about apt-utils
#RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get -q update && apt-get install --assume-yes apt-utils

#requirement for Swift Module 'SSLService' ?
RUN apt-get -q install -y libssl-dev

#RUN echo "Install Dependencies"
RUN apt-get -q update && \
    apt-get -q install -y \
    make \
    libc6-dev \
    clang-3.6 \
    curl \
    libedit-dev \
    python2.7 \
    python2.7-dev \
    libicu-dev \
    rsync \
    libxml2 \
    git \
	wget \
    libcurl4-openssl-dev \
    && update-alternatives --quiet --install /usr/bin/clang clang /usr/bin/clang-3.6 100 \
    && update-alternatives --quiet --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.6 100 \
    && rm -r /var/lib/apt/lists/*


#RUN echo "Install Swift keys"
RUN wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import - && \
    gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

#RUN echo "Download and install Swift with wget"
RUN SWIFT_ARCHIVE_NAME=swift-$SWIFT_VERSION-$SWIFT_PLATFORM && \
   SWIFT_URL=$SWIFT_INSTALL_URL && \
	echo "SWIFT_URL: $SWIFT_URL" && \
	echo "SWIFT_ARCHIVE_NAME: $SWIFT_ARCHIVE_NAME" && \	
    wget $SWIFT_URL && \
    wget $SWIFT_URL.sig && \
    tar -xvzf $SWIFT_ARCHIVE_NAME.tar.gz -C / --strip 1 && \
    rm -rf $SWIFT_ARCHIVE_NAME* /tmp/* /var/tmp/*

RUN echo "expose ports"
#Expose 80
#Expose 8080
Expose 8090

# Add swift to the path
ENV PATH /usr/bin:$PATH

ADD . /yachtsServer
WORKDIR /yachtsServer

#Build the swift App
#RUN swift build --configuration release
#ENTRYPOINT [".build/release/yachtsServer"]

#RUN swift build
#ENTRYPOINT [".build/debug/yachtsServer"]
