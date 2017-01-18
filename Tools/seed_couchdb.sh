#!/bin/bash -e
 
# This script is inspired from similar scripts in the Kitura BluePic project
 
# Find our current directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 
# Parse input parameters
database=yachts
url=http://localhost:5984

for i in "$@"
do
case $i in
    --username=*)
    username="${i#*=}"
    shift
    ;;
    --password=*)
    password="${i#*=}"
    shift
    ;;
    --url=*)
    url="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done
 
if [ -z $username ]; then
  echo "Usage:"
  echo "seed_couchdb.sh --username=<username> --password=<password> [--url=<url>]"
  echo "    default for --url is '$url'"
#  exit
fi

if [ -z $username ]; then
	#no username and password was provided
	# delete and create database to ensure it's empty
	curl -X DELETE $url/$database
	curl -X PUT $url/$database
 
	# Upload design document
	curl -X PUT "$url/$database/_design/main_design" \
	    -d @$current_dir/main_design.json
 
	# Create data
	curl -H "Content-Type: application/json" -d @$current_dir/yachts.json \
	    -X POST $url/$database/_bulk_docs

else	
	# delete and create database to ensure it's empty
	curl -X DELETE $url/$database -u $username:$password
	curl -X PUT $url/$database -u $username:$password
 
	# Upload design document
	curl -X PUT "$url/$database/_design/main_design" -u $username:$password \
	    -d @$current_dir/main_design.json
 
	# Create data
	curl -H "Content-Type: application/json" -d @$current_dir/yachts.json \
	    -X POST $url/$database/_bulk_docs -u $username:$password

fi

echo
echo "Finished populating couchdb database '$database' on '$url'"