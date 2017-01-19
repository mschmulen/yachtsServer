
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import yachtsShare

class UserService {

  var dataStore: (()-> Datastore)?
  
  func getAll(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
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
          dictionary["avatarURL"] = doc["doc"]["avatarURL"].stringValue

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

        let model = User.deserialize(dictionary: dictionary)

        let result: [String: Any] = ["result": status, "data": model.serialize() as [String:Any] ]
        let json = JSON(result)
        response.status(.OK).send(json: json)
      }
    }
  }

  public let deleteModel:RouterHandler = { request,response,next in
    defer { next() }

    guard let id = request.parameters["id"] else {
      response.status(.badRequest).send("Missing id")
      return
    }

    SingletonDatastore.sharedInstance.database.retrieve(id) { doc, error in
      if let error = error {
        let errorMessage = error.localizedDescription
        let status = ["status": "error", "message": errorMessage]
        let	result = ["result": status]
        let json = JSON(result)

        response.status(.notFound).send(json: json)
      } else if let doc = doc {
        var newDocument = doc
        let id = doc["_id"].stringValue
        let rev = doc["_rev"].stringValue

        SingletonDatastore.sharedInstance.database.delete(id, rev: rev) { error in
          if let error = error {
            let errorMessage = error.localizedDescription
            let status = ["status": "error", "message": errorMessage]
            let	result = ["result": status]
            let json = JSON(result)
            response.status(.notFound).send(json: json)
          } else {
            let status = ["status": "ok"]
            let result: [String: Any] = ["result": status, "message": "instance \(id) deleted" ]
            let json = JSON(result)
            response.status(.OK).send(json: json)
          }
        }
      }//end if let doc
    }//end retrieve by id so as to get a revision number
  }

  public let postCreate:RouterHandler = { request,response,next in
    defer { next() }

    guard let values = request.body else {
      try response.status(.badRequest).end()
      return
    }

    // MAS TODO move to shared
    let fields = ["name", "email"]
    var postData = [String: Any]()

    switch ( values ) {
    case .json(let body):
      print("json encoded \(body)")

      for field in fields {
        if let value = body[field].string {
          postData[field] = value
          continue
        }
        try response.status(.badRequest).end()
        return
      }

    case .urlEncoded(let body) :
      print("url encoded \(body)")

      for field in fields {
        if let value = body[field]?.trimmingCharacters(in: .whitespacesAndNewlines) {
          if value.characters.count > 0 {
            postData[field] = value.removingHTMLEncoding()
            continue
          }
        }

        try response.status(.badRequest).end()
        return
      }
    case .multipart(let body) :
      print( " this is a multipart post and is not supported")
      try response.status(.badRequest).end()
    default:
      try response.status(.badRequest).end()
    }//end switch

    let json = JSON(postData)
    SingletonDatastore.sharedInstance.database.create(json) { id, revision, doc, error in

      if let id = id {
        let status = ["status": "ok", "id": id]
        let	result = ["result": status]
        let json = JSON(result)

        response.status(.OK).send(json: json)
      } else {
        let errorMessage = error?.localizedDescription ?? "Unknown error"
        let status = ["status": "error", "message": errorMessage]
        let	result = ["result": status]
        let json = JSON(result)

        response.status(.internalServerError).send(json: json)
      }
    }
    
  }


  

}
