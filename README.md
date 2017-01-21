
Evaluation demo and prototype for sharing swift server side code modules with native iOS clients.

##Abstract

Open source [Swift](https://swift.org/) support on server machines makes it possible for developers to use common code modules on both the server and in native iOS app clients.  This project explores how sharing code modules between the server and the client may accelerate development, improve reliability and/or reduce the overall cost of delivery and maintenance for swift iPhone apps.

JavaScript and Java Android developers have some great examples on taking advantage of this such as how [airbnb leverages Isomorphic JavaScript](http://nerds.airbnb.com/isomorphic-javascript-future-web-apps/) using [nodejs](https://nodejs.org/) to improve their application delivery.

This app shares [kitura](http://www.kitura.io/) web API server side [model structs and their JSON and dictionary serializers](https://github.com/mschmulen/yachtsShare) with the native iOS mobile app using [Swift Package Manager (SPM)](https://swift.org/package-manager/) and [Cathage](https://github.com/Carthage/Carthage) to insure API model dependencies via semantic versioning.

Use the [Building and running with Docker](#building-and-running-with-docker) to quick start the API server infastructure and then build and run the [companion mobile iPhone app](https://github.com/mschmulen/yachtsApp) to utilize the API on local host.

- Swift Server [https://github.com/mschmulen/yachtsServer](https://github.com/mschmulen/yachtsServer)
- iOS App [https://github.com/mschmulen/yachtsApp](https://github.com/mschmulen/yachtsApp)
- Common shared Swift package for isomorphic models [https://github.com/mschmulen/yachtsShare](https://github.com/mschmulen/yachtsShare)

##Building and running with docker compose

###Prerequisites

- Docker and docker-compose [https://www.docker.com/](https://www.docker.com/)

###Running with docker compose 

1. Clone the repo `git clone git@github.com:mschmulen/yachtsServer && cd yachtsServer`
1. Copy example.env to .env with `cp example.env .env`
1. Init and run with `docker-compose up`
1. Intialize the data store with `Tools/seed_couchdb.sh` you can modify the seed data from the json doc files `Tools/yachts.json`
1. Verify with open [http://localhost:8090/](http://localhost:8090/) and [http://localhost:8090/yachts](http://localhost:8090/yachts)
1. Run the iOS app [https://github.com/mschmulen/yachtsApp](https://github.com/mschmulen/yachtsApp)

##Building and running local OSX configuration

###Prerequisites

- Verify version 3.0.2 with `swift -v` or follow the getting started at [https://swift.org/getting-started/](https://swift.org/getting-started/)
- Xcode

###Building and running the server with Xcode or local SPM ( Swift Package Manager)

Building and running with command line SPM (Swift Package Manager)

1. Clone the repo `git clone git@github.com:mschmulen/yachtsServer && cd yachtsServer`
1. Build `swift build`
1. Insure the [couchdb](http://couchdb.apache.org/) data store is running local or via a local docker host
1. Seed the couchDB datastore `Tools/seed_couchdb.sh --username=matt --password=123456` (verify your local credentials)
1. Run the server with `.build/debug/yachtsServer`

Building and running with Xcode 

1. Clone the repo `git clone git@github.com:mschmulen/yachtsServer && cd yachtsServer`
1. Generating the Xcode project `swift package generate-xcodeproj`
1. Open in Xcode `open yachtsServer.xcodeproj`
1. Insure the [couchdb](http://couchdb.apache.org/) data store is running local or via a local docker host
1. Seed the couchDB datastore `Tools/seed_couchdb.sh --username=matt --password=123456` (verify your local credentials)
1. Make sure and select the cmd line target then build and run with  `⌘ + r`

Verify the server is running [ttp://localhost:8090](ttp://localhost:8090) and [http://localhost:8090/yachts])http://localhost:8090/yachts

##Run the companion iOS app

Follow the instructions on the Companion iOS App [https://github.com/mschmulen/yachtsApp](https://github.com/mschmulen/yachtsApp)

--- 

##Misc Docker commands

- show images: `docker images`
- show images: `docker ps -a`
- run with interactive and privlileged: `docker run --privileged -i -t --name yachts-swift-server mschmulen/swift-server:latest /bin/bash`
- start a docker image: `docker start yachts-swift-server`
- attach to a running image: `docker attach yachts-swift-server`
- Clean up dangling images `docker rmi $(docker images -f "dangling=true" -q)`
- One liner to stop all of Docker containers: `docker stop $(docker ps -a -q)`


##Special Thanks !

Special thanks too [erutherford](https://github.com/erutherford), [jessecravens](https://github.com/jessecravens), [thedodd](https://github.com/thedodd), [sharplet](https://github.com/sharplet), [kristenfelch](https://github.com/kristenfelch), and especially  [rlwimi](https://github.com/rlwimi) for taking the time to review, provide thier expert advice on the development and goals this prototype project.


Thanks to [insanoid](https://github.com/insanoid) for his work on [SwiftyJSONAccelerator](https://github.com/insanoid/SwiftyJSONAccelerator), its a great tool for creating Swift model structs from JSON stubs.

The Kitura Swift web and HTTP server framework [https://github.com/IBM-Swift/Kitura](https://github.com/IBM-Swift/Kitura) project.

--- 


##Deploying to a provider WIP 

####DigitalOcean (usering docker-machine) :

Prerequisites: 

- Docker machine [https://www.docker.com/products/docker-machine](https://www.docker.com/products/docker-machine)
- Digital ocean TOKEN

Getting up and running:

1. Create the droplet: `docker-machine create --driver digitalocean --digitalocean-access-token [TOKEN] yachtsServer`
1. Get the environment: `docker-machine env yachtsServer`
1. Configure the environment: `eval $(docker-machine env yachtsServer)`
1. Build the image: `docker build -t swift-server .`
1. Run the image on the host: `docker run --name webserver -p 80:8090 swift-server` . The -p option is used to expose port 80 from the nginx container and make it accessible on port 8090 of the swift-server-image host

Docker machine common commands:

- Get the ip address: `docker-machine ip yachtsServer`
- Inspect: `docker-machine inspect yachtsServer`
- Show docker machines: `docker-machine ls`
- Connect to the docker machine: `docker-machine ssh yachtsServer`
- Stop: `docker-machine stop yachtsServer`
- Remove: `docker-machine rm yachtServer`

####Deploying via ibm bluemix:

**note bluemix does not have a freemium offer and you will be charged mercilessly per minute**

1. create an account at [ibm bluemix](https://www.ibm.com/cloud-computing/bluemix/swift)
1. cf login -a api.ng.bluemix.net
1. cf push "yachts"

delete your app with : `cf delete "yachts"`


###Misc References

Docker and Provider references:

An Ubuntu 16.04 Docker image for Swift [https://github.com/swiftdocker/docker-swift](https://github.com/swiftdocker/docker-swift).  Run with `docker run --privileged -i -t --name swiftfun swiftdocker/swift:latest /bin/bash`

Digital ocean Docker
[https://docs.docker.com/machine/examples/ocean/](https://docs.docker.com/machine/examples/ocean/)

Digital Ocean Server Side Swift
[https://medium.com/@LarsJK/easy-server-side-swift-with-docker-4c297feeeeb5#.1g5i8ilmq](https://medium.com/@LarsJK/easy-server-side-swift-with-docker-4c297feeeeb5#.1g5i8ilmq) and corresponding github repo [https://github.com/serversideswift/swift-docker/blob/master/Dockerfile](https://github.com/serversideswift/swift-docker/blob/master/Dockerfile)

IBM Swift docker examples [https://github.com/IBM-MIL/Samples](https://github.com/IBM-MIL/Samples)

Docker hub: twostraws Swift Server [https://hub.docker.com/r/twostraws/server-side-swift/](https://hub.docker.com/r/twostraws/server-side-swift/) docker file reference 

IBM Simple swift docker configuration [https://developer.ibm.com/swift/2015/12/15/running-swift-within-docker/](https://developer.ibm.com/swift/2015/12/15/running-swift-within-docker/) 

Couch DB Docker file reference [https://github.com/apache/couchdb-docker/blob/master/2.0-dev-docs/Dockerfile](https://github.com/apache/couchdb-docker/blob/master/2.0-dev-docs/Dockerfile)


Code Sharing between server and client:

How to Implement Node + React Isomorphic JavaScript & Why it Matters , StrongLoop :
[https://strongloop.com/strongblog/node-js-react-isomorphic-javascript-why-it-matters/](https://strongloop.com/strongblog/node-js-react-isomorphic-javascript-why-it-matters/)

Isomorphic JavaScript: The Future of Web Apps , airbnb : [http://nerds.airbnb.com/isomorphic-javascript-future-web-apps/](http://nerds.airbnb.com/isomorphic-javascript-future-web-apps/)

[https://blog.algolia.com/modern-javascript-libraries-the-isomorphic-way/](https://blog.algolia.com/modern-javascript-libraries-the-isomorphic-way/)

Share POJO Entity Data Classes between Android and Spring projects [http://stackoverflow.com/questions/31566303/share-pojo-entity-data-classes-between-android-and-spring-projects](http://stackoverflow.com/questions/31566303/share-pojo-entity-data-classes-between-android-and-spring-projects)


Swift:

OSX app and CLI to generate Swift 3 code for models from JSON. [https://github.com/insanoid/SwiftyJSONAccelerator](https://github.com/insanoid/SwiftyJSONAccelerator)


An implementation (validator) of JSON Schema in Swift [https://github.com/kylef/JSONSchema.swift](https://github.com/kylef/JSONSchema.swift)

Scheme generator in ruby [https://github.com/maxlinc/json-schema-generator](https://github.com/maxlinc/json-schema-generator)

Scheme generator in scala [https://github.com/VoxSupplyChain/json-schema-codegen](https://github.com/VoxSupplyChain/json-schema-codegen)

Data Modeling Framework for JSON [https://github.com/jsonmodel/jsonmodel](https://github.com/jsonmodel/jsonmodel)


Embedded web server for iOS UI testing [https://envoy.engineering/embedded-web-server-for-ios-ui-testing-8ff3cef513df#.srl7p1x5p](https://envoy.engineering/embedded-web-server-for-ios-ui-testing-8ff3cef513df#.srl7p1x5p)


Scheme management:

Swagger integrations [http://swagger.io/open-source-integrations/](http://swagger.io/open-source-integrations/)

Swagger swift gen [https://github.com/yonaskolb/SwagGen](https://github.com/yonaskolb/SwagGen)

api blueprint [https://apiblueprint.org/tools.html](https://apiblueprint.org/tools.html)

--- 

###Misc Notes (the Attic)

####TODO 

- push to Docker Hub repo so it can be run via docker-compose reference

####SwiftyJSONAccelerator

Install

1. `git clone https://github.com/insanoid/SwiftyJSONAccelerator.git && cd SwiftyJSONAccelerator`
1. `make install`
1. `cd ..`
1. `rm -rf SwiftyJSONAccelerator`

Run using `.config.json`

1. generate: `swiftyjsonaccelerator generate -p Definitions`
1. from the Definitions folder `cd ~/yachtsServer/Definitions`
1. generate: `swiftyjsonaccelerator generate`

note inject `import SwiftyJSON` into Model objects

---


####run the docker hub twostraws/server-side-swift image

1. `mkdir docker-server`
1. `cd docker-server`
1. `docker run -itv $(pwd):/swiftServer --name swiftServer -w /swiftServer -p 8089:8089 -p 8090:8090 -p 5984:5984 twostraws/server-side-swift /bin/bash`

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




