
#FROM ubuntu:15.10
FROM ubuntu:16.04

ENV SWIFT_VERSION 3.0.2-RELEASE
ENV SWIFT_PLATFORM ubuntu16.04
ENV SWIFT_INSTALL_URL https://swift.org/builds/swift-3.0.2-release/ubuntu1604/swift-3.0.2-RELEASE/swift-3.0.2-RELEASE-ubuntu16.04.tar.gz

# Install Dependencies
RUN apt-get update && \
    apt-get install -y \
        clang \
        libicu55 \
        libpython2.7 \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Swift keys
RUN wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import - && \
    gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

# Download and install Swift
RUN SWIFT_ARCHIVE_NAME=swift-$SWIFT_VERSION-$SWIFT_PLATFORM && \
    SWIFT_URL=$SWIFT_INSTALL_URL && \
	echo "SWIFT_URL: $SWIFT_URL" && \
	echo "SWIFT_ARCHIVE_NAME: $SWIFT_ARCHIVE_NAME" && \	
    wget $SWIFT_URL && \
    wget $SWIFT_URL.sig && \
    tar -xvzf $SWIFT_ARCHIVE_NAME.tar.gz -C / --strip 1 && \
    rm -rf $SWIFT_ARCHIVE_NAME* /tmp/* /var/tmp/*

#Expose Port 80 by uncommenting the following.
Expose 80
Expose 8090

## LEGACY
#FROM swiftdocker/swift
ADD . /yachtsServer
WORKDIR /yachtsServer
#RUN swift build --configuration release
#RUN swift build
#ENTRYPOINT [".build/release/yachtsServer"]
#ENTRYPOINT [".build/debug/yachtsServer"]


