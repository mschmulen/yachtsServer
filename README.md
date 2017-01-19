yachtsServer
===

Evaluation demo for using Isomorphic swift model structs on the server and the client.

- Companion Swift Server [https://github.com/mschmulen/yachtsServer](https://github.com/mschmulen/yachtsServer)
- Companion iOS App [https://github.com/mschmulen/yachtsApp](https://github.com/mschmulen/yachtsApp)
- Common shared Swift package for isomorphic models [https://github.com/mschmulen/yachtsShare](https://github.com/mschmulen/yachtsShare)

##Building and running with Docker

###prerequisites

- Docker [https://www.docker.com/](https://www.docker.com/)

###running with docker compose 

1. clone the repo `git clone git@github.com:mschmulen/yachtsServer && cd yachtsServer`
1. copy example.env to .env with `cp example.env .env`
1. init and run with `docker-compose up`
1. intialize the data store with `Tools/seed_couchdb.sh` you can modify the seed data from the json doc files `Tools/yachts.json`
1. verify with open [http://localhost:8090/](http://localhost:8090/) and [http://localhost:8090/yachts](http://localhost:8090/yachts)
1. run the iOS app [https://github.com/mschmulen/yachtsApp](https://github.com/mschmulen/yachtsApp)

##Building and running local OSX configuration

###prerequisites

- verify version 3.0.2 with `swift -v` or follow the getting started at [https://swift.org/getting-started/](https://swift.org/getting-started/)
- XCode

###Building and running the server with XCode or local SPM ( Swift Package Manager)

Building and running with command line SPM (Swift Package Manager)

1. Clone the repo `git clone git@github.com:mschmulen/yachtsServer && cd yachtsServer`
1. build `swift build`
1. Install and start [couchdb](http://couchdb.apache.org/) locally
1. Seed the couchDB datastore - seed couchdb `Tools/seed_couchdb.sh --username=matt --password=123456` ( verify your local credentials)
1. run the server with `.build/debug/yachtsServer`

Building and running with XCode 

1. Clone the repo `git clone git@github.com:mschmulen/yachtsServer && cd yachtsServer`
1. Generating the xcode project `swift package generate-xcodeproj`
1. Open in xCode `open yachtsServer.xcodeproj`
1. Install and start [couchdb](http://couchdb.apache.org/) locally
1. Seed the couchDB datastore - seed couchdb `Tools/seed_couchdb.sh --username=matt --password=123456` ( verify your local credentials)
1. Make sure and select the cmd line target then build and run with  `⌘ + r`

Verify the server is running [localhost:8090](localhost:8090) and [http://localhost:8090/yachts])http://localhost:8090/yachts


##Run the companion iOS app

Follow the instructions on the Companion Swift Server [https://github.com/mschmulen/yachtsServer](https://github.com/mschmulen/yachtsServer)


--- 

##Deploying to a provider WIP 

####DigitalOcean:

Prerequisites: 

- docker machine [https://www.docker.com/products/docker-machine](https://www.docker.com/products/docker-machine)
- digital ocean TOKEN

Getting up and running:

1. create the droplet: `docker-machine create --driver digitalocean --digitalocean-access-token [TOKEN] yachtsServer`
1. get the environment: `docker-machine env yachtsServer`
1. configure the environment: `eval $(docker-machine env yachtsServer)`
1. build the image: `docker build -t swift-server .`
1. run the image on the host: `docker run --name webserver -p 80:8090 swift-server` . The -p option is used to expose port 80 from the nginx container and make it accessible on port 8090 of the swift-server-image host

Misc:

get the ip address: `docker-machine ip yachtsServer`

inspect: `docker-machine inspect yachtsServer`

show docker machines: `docker-machine ls`

connect to the docker machine: `docker-machine ssh yachtsServer`

Stop and remove the machine from Digital Ocean:

1. stop: `docker-machine stop yachtsServer`
1. remove: `docker-machine rm yachtServer`


####Deploying via bluemix:

1. bluemix login
1. cf push "yachts"

delete your app with : `cf delete "yachts"`

##Misc Docker commands

- show images `docker images`
- show images `docker ps -a`
- docker run --privileged -i -t --name yachts-swift-server mschmulen/swift-server:latest /bin/bash
- docker start yachts-swift-server
- docker attach yachts-swift-server
- clean up dangling images `docker rmi $(docker images -f "dangling=true" -q)`
- One liner to stop all of Docker containers: `docker stop $(docker ps -a -q)`

###Misc References

[https://github.com/swiftdocker/docker-swift](https://github.com/swiftdocker/docker-swift)

IBM Swift docker examples [https://github.com/IBM-MIL/Samples](https://github.com/IBM-MIL/Samples)

Digital ocean Docker
[https://docs.docker.com/machine/examples/ocean/](https://docs.docker.com/machine/examples/ocean/)

Digital Ocean Server Side Swift
[https://medium.com/@LarsJK/easy-server-side-swift-with-docker-4c297feeeeb5#.1g5i8ilmq](https://medium.com/@LarsJK/easy-server-side-swift-with-docker-4c297feeeeb5#.1g5i8ilmq) and corresponding github repo [https://github.com/serversideswift/swift-docker/blob/master/Dockerfile](https://github.com/serversideswift/swift-docker/blob/master/Dockerfile)


Couch DB Docker file reference [https://github.com/apache/couchdb-docker/blob/master/2.0-dev-docs/Dockerfile](https://github.com/apache/couchdb-docker/blob/master/2.0-dev-docs/Dockerfile)


Docker Hub Swift Server [https://hub.docker.com/r/twostraws/server-side-swift/](https://hub.docker.com/r/twostraws/server-side-swift/) docker file reference 

https://hub.docker.com/r/rocker/drd/~/dockerfile/

Simple swift docker configuration [https://developer.ibm.com/swift/2015/12/15/running-swift-within-docker/](https://developer.ibm.com/swift/2015/12/15/running-swift-within-docker/) 


--- 

###Misc Notes (the Attic)

####TODO 

- push to Docker Hub repo so it can be run via docker-compose reference

--- 

docker run --privileged -i -t --name swiftfun swiftdocker/swift:latest /bin/bash


---


####run the docker hub twostraws/server-side-swift image
```
mkdir docker-server
cd docker-server
docker run -itv $(pwd):/swiftServer --name swiftServer -w /swiftServer -p 8089:8089 -p 8090:8090 -p 5984:5984 twostraws/server-side-swift /bin/bash
```

run via twostraws image `docker run -itv $(pwd):/swiftServer --name swiftServer -w /swiftServer -p 8089:8089 -p 8090:8090 -p 5984:5984 twostraws/server-side-swift /bin/bash`

#### run the docker container locally

1. from the yachtsServer repo : `cd yachtsServer`
1. build the image: `docker build -t yachts-swift-server .`
1. verify the image was build: `docker images`
1. run the docker image with: `docker run -it --name webserver -p 8090:8090 -p 5984:5984 yachts-swift-server` this will name the service ‘webserver’, replace the `-p 80:8090` to make the image’s port 8090 available on the hosts port 80.
1. open a web page http://localhost:8090/ to verify the server is runing  pr `http://localhost:8090/yachts` to verify the API is working

you can verfy swift was configured correctly with `docker run -it yachts-swift-server /bin/bash` and `swift --version` from the interactive terminal

####local docker workflow

After building the yachts-swift-server image (instructions above):

1. terminal to the container `docker run -it yachts-swift-server /bin/bash`
1. `pwd` to confirm SwiftServer folder
1. clean and build `rm -rf .build/ && swift build`
1. run the server from the terminal with `.build/debug/yachtsServer`

####Configuring CouchDB

1. Install CouchDB : http://couchdb.apache.org/#download 
2. Verify CouchDB is running `open http://127.0.0.1:5984/_utils/` , `http://localhost:5984/`, or `curl -X GET http://localhost:5984`
3. initialize with the script `Tools/initDB`

#### from within the docker container

- start the couchdb server from within the docker container with `/etc/init.d/couchdb start`
- seed couchdb `Tools/seed_couchdb.sh --username=matt --password=123456`
- build ad run the yacht-server from within the docker container with `swift build && .build/debug/yachtsServer`

#### misc commands 

- run and attach: `docker start -i swiftServer`




