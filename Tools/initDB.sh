

COUCH="localhost:5984"
JSON="Content-Type:application/json"

# Create the store

curl -X PUT $COUCH/yachts
curl -X DELETE $COUCH/yachts
curl -X GET $COUCH/yachts
curl -X PUT $COUCH/yachts
curl -X GET $COUCH/yachts

# Add records

curl -X POST -H $JSON $COUCH/yachts -d '{"name": "Valiant 39", "url": "http://bluewaterboats.org/valiant-39/", "architect": "Robert H. Perry", "likes": 0, "imageURL":"https://s-media-cache-ak0.pinimg.com/236x/e5/62/f2/e562f2ca779b4cdb50f10f97bd3c8b4b.jpg" }'
curl -X POST -H $JSON $COUCH/yachts -d '{"name": "Baba 35", "url": "http://bluewaterboats.org/baba-35/", "architect": "Robert H. Perry", "likes": 0, "imageURL":"https://s-media-cache-ak0.pinimg.com/236x/e5/62/f2/e562f2ca779b4cdb50f10f97bd3c8b4b.jpg"}'
curl -X POST -H $JSON $COUCH/yachts -d '{"name": "Tayana 37", "url": "http://bluewaterboats.org/tayana-37/", "architect": "Robert H. Perry", "likes": 0, "imageURL":"https://s-media-cache-ak0.pinimg.com/236x/e5/62/f2/e562f2ca779b4cdb50f10f97bd3c8b4b.jpg"}'
curl -X POST -H $JSON $COUCH/yachts -d '{"name": "Valiant esprit 37", "url": "http://bluewaterboats.org/valiant-esprit-37/", "architect": "Robert H. Perry", "likes": 0, "imageURL":"https://s-media-cache-ak0.pinimg.com/236x/e5/62/f2/e562f2ca779b4cdb50f10f97bd3c8b4b.jpg"}'
curl -X POST -H $JSON $COUCH/yachts -d '{"name": "Valiant 40", "url": "http://bluewaterboats.org/valiant-40/", "architect": "Robert H. Perry", "likes": 0, "imageURL":"https://s-media-cache-ak0.pinimg.com/236x/e5/62/f2/e562f2ca779b4cdb50f10f97bd3c8b4b.jpg"}'
curl -X POST -H $JSON $COUCH/yachts -d '{"name": "Valiant 42", "url": "http://bluewaterboats.org/valiant-42/", "architect": "Robert H. Perry", "likes": 0, "imageURL":"https://s-media-cache-ak0.pinimg.com/236x/e5/62/f2/e562f2ca779b4cdb50f10f97bd3c8b4b.jpg"}'

#list all
curl -X GET $COUCH/yachts/_all_docs?include_docs=true



# Create the user

curl -X PUT $COUCH/users
curl -X DELETE $COUCH/users
curl -X GET $COUCH/users
curl -X PUT $COUCH/users
curl -X GET $COUCH/users

curl -X POST -H $JSON $COUCH/users -d '{"name": "Matt", "email": "matt@jumptack.com", "password": "password" }'
curl -X POST -H $JSON $COUCH/users -d '{"name": "test", "email": "test@test.com", "password": "test" }'

curl -X GET $COUCH/users/_all_docs?include_docs=true


# end