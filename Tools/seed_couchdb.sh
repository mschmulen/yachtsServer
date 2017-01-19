#!/bin/bash -e
 
# This script is inspired from similar scripts in the Kitura BluePic project
 
# Find our current directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 
# Parse input parameters
database_yachts=yachts
database_users=users

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
	username=matt
	password=123456
fi

# yachts
# delete and create database to ensure it's empty
curl -X DELETE $url/$database_yachts -u $username:$password
curl -X PUT $url/$database_yachts -u $username:$password
# Upload design document
curl -X PUT "$url/$database_yachts/_design/main_design" -u $username:$password \
    -d @$current_dir/main_design.json
# Create data
curl -H "Content-Type: application/json" -d @$current_dir/yachts.json \
    -X POST $url/$database_yachts/_bulk_docs -u $username:$password

# users	
# delete and create database to ensure it's empty
curl -X DELETE $url/$database_users -u $username:$password
curl -X PUT $url/$database_users -u $username:$password 
# Upload design document
curl -X PUT "$url/$database_users/_design/main_design" -u $username:$password \
    -d @$current_dir/main_design.json 
# Create data
curl -H "Content-Type: application/json" -d @$current_dir/users.json \
    -X POST $url/$database_users/_bulk_docs -u $username:$password

echo
echo "Finished populating couchdb database '$database' on '$url'"