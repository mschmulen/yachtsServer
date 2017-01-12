yachtsServer
===

Evaluation demo for using Isomorphic swift model structs on the server and the client.

- Companion Swift Server [https://github.com/mschmulen/yachtsServer](https://github.com/mschmulen/yachtsServer)
- Companion iOS App [https://github.com/mschmulen/yachtsApp](https://github.com/mschmulen/yachtsApp)
- Common shared Swift package for isomorphic models [https://github.com/mschmulen/yachtsShare](https://github.com/mschmulen/yachtsShare)

##Docker configuration

####create the docker container
```
mkdir docker-server
cd docker-server
docker run -itv $(pwd):/swiftServer --name swiftServer -w /swiftServer -p 8089:8089 -p 8090:8090 -p 5984:5984 twostraws/server-side-swift /bin/bash
```

#### clone the repo to the shared folder
```
git clone git@github.com:mschmulen/yachtsServer
cd yachtsServer 
```

#### from within the docker container

- start the couchdb server from within the docker container with `/etc/init.d/couchdb start`
- initialize the db from within the docker container with `Tools\initDB`
- build ad run the yacht-server from within the docker container with `swift build && .build/debug/yachtsServer`

#### verify
`open http://localhost:8090/yachts`

#### misc commands 

- run and attach: `docker start -i swiftServer`

##Local OSX configuration

####Swift 

version 3.0.2

`swift -v`

####Configuring CouchDB

1. Install CouchDB : http://couchdb.apache.org/#download 
2. Verify CouchDB is running `open http://127.0.0.1:5984/_utils/` , `http://localhost:5984/`, or `curl -X GET http://localhost:5984`
3. initialize with the script `Tools/initDB`

####Building and running the server

building and running via command line:

from the server folder with `swift build && .build/debug/yachtsServer`

building and running with xCode :

1. Generating the xcode project `swift package generate-xcodeproj`
1. Open in xCode `open yachtsServer.xcodeproj`
1. Make sure and select the cmd line target then build and run with  `⌘ + r`

#### Services and endpoints

- [http://localhost:8090/](http://localhost:8090/)
- [http://localhost:8090/yachts](http://localhost:8090/yachts)