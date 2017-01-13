FROM swiftdocker/swift
ADD . /yachtsServer
WORKDIR /yachtsServer
RUN swift build --configuration release
EXPOSE 8090
ENTRYPOINT [".build/release/yachtsServer"]