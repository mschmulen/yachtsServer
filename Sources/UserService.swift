
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import yachtsShare

//extension User {
//  func serialize() -> JSON {
//    let model:[String: Any] = serialize()
//    let json = JSON(model)
//    return json
//  }
//}

class UserService {

  var dataStore: (()-> Datastore)?

  func getAllModels(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
    defer { next() }

    dataStore?().database.retrieveAll(includeDocuments: true) { docs, error in
      if let error = error {
        let errorMessage = error.localizedDescription
        let status = ["status": "error", "message": errorMessage]
        let	result = ["result": status]
        let json = JSON(result)
        response.status(.notFound).send(json: json)
      } else if let docs = docs {

        let status = ["status": "ok"]
        var models = [User]()

        for (_,doc) in docs["rows"].arrayValue.enumerated() {
          var dictionary = [String: Any]()
          dictionary["id"] = doc["id"].stringValue
          dictionary["name"] = doc["doc"]["name"].stringValue
          dictionary["email"] = doc["doc"]["email"].stringValue
          dictionary["imageURL"] = doc["doc"]["imageURL"].stringValue

          let m = User.deserialize(dictionary: dictionary)
          models.append(m)
        }

        var modelsDictionary = [[String: Any]]()
        for model in models {
          modelsDictionary.append(model.serialize())
        }

        let result: [String: Any] = ["result": status, "data": modelsDictionary]
        let json = JSON(result)
        response.status(.OK).send(json: json)
      }
    }
  }

  func getModel(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
    defer { next() }

    guard let yacht = request.parameters["id"] else {
      response.status(.badRequest).send("Missing id")
      return
    }

    dataStore?().database.retrieve(yacht) { doc, error in

      if let error = error {
        let errorMessage = error.localizedDescription
        let status = ["status": "error", "message": errorMessage]
        let	result = ["result": status]
        let json = JSON(result)

        response.status(.notFound).send(json: json)
      } else if let doc = doc {
        let status = ["status": "ok"]

        var dictionary = [String: Any]()
        dictionary["id"] = doc["_id"].stringValue
        dictionary["name"] = doc["name"].stringValue
        dictionary["email"] = doc["email"].stringValue
        dictionary["imageURL"] = doc["imageURL"].stringValue

        let model = User.deserialize(dictionary: dictionary)

        let result: [String: Any] = ["result": status, "data": model.serialize() as [String:Any] ]
        let json = JSON(result)
        response.status(.OK).send(json: json)
      }
    }
  }
  

}
