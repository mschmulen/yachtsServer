
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import yachtsShare

// architect model extension
//extension Architect {
//  func serialize() -> JSON {
//    let model:[String: Any] = serialize()
//    let json = JSON(model)
//    return json
//  }
//}

//typealias ArchitectModel = ModelArchitect
public class ArchitectService {

  var dataStore: (()-> Datastore)?

//  //Find all instances matched by filter from the datastore
//  public func getAll(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer { next() }
//    
//    SingletonDatastore.sharedInstance.database.retrieveAll(includeDocuments: true) { docs, error in
//      if let error = error {
//        let errorMessage = error.localizedDescription
//        let status = ["status": "error", "message": errorMessage]
//        let	result = ["result": status]
//        let json = JSON(result)
//        response.status(.notFound).send(json: json)
//      } else if let docs = docs {
//
//        //      let total_rows = docs["total_rows"].stringValue
//        //      let offset = docs["offset"].stringValue
//        //      Log.info("total_rows: \(total_rows)")
//        //      Log.info("offset: \(offset)")
//
//        let status = ["status": "ok"]
//        var models = [ModelArchitect]()
//
//        for doc in docs["rows"].arrayValue {
//          var dictionary = [String: Any]()
//          dictionary["id"] = doc["id"].stringValue
//          dictionary["name"] = doc["doc"]["name"].stringValue
//          dictionary["url"] = doc["doc"]["url"].stringValue
//          dictionary["architect"] = doc["doc"]["architect"].stringValue
//          dictionary["likes"] = doc["doc"]["like"].intValue
//          dictionary["imageURL"] = doc["doc"]["imageURL"].stringValue
//
//          let m = Architect.deserialize(dictionary: dictionary)
//          models.append(m)
//        }
//
//        var modelsDictionary = [[String: Any]]()
//        for model in models {
//          modelsDictionary.append(model.serialize())
//        }
//
//        let result: [String: Any] = ["result": status, "data": modelsDictionary]
//        let json = JSON(result)
//        response.status(.OK).send(json: json)
//      }
//    }
//  }
//
//  //Create a new instance of the model and persist it in the datastore
//  public func postCreate(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer { next() }
//
//    guard let values = request.body else {
//      try response.status(.badRequest).end()
//      return
//    }
//
//    // MAS TODO move to shared
//    let createfields = ["name", "architect", "url"]
//    var postData = [String: Any]()
//
//    switch ( values ) {
//    case .json(let body):
//      for field in createfields {
//        if let value = body[field].string {
//          postData[field] = value
//          continue
//        }
//        try response.status(.badRequest).end()
//        return
//      }
//
//    case .urlEncoded(let body) :
//      for field in createfields {
//        if let value = body[field]?.trimmingCharacters(in: .whitespacesAndNewlines) {
//          if value.characters.count > 0 {
//            postData[field] = value.removingHTMLEncoding()
//            continue
//          }
//        }
//
//        try response.status(.badRequest).end()
//        return
//      }
//    case .multipart(let body) :
//      print( " this is a multipart post and is not supported \(body)")
//      try response.status(.badRequest).end()
//    default:
//      try response.status(.badRequest).end()
//    }//end switch
//
//    postData["likes"] = 0
//    let json = JSON(postData)
//
//    SingletonDatastore.sharedInstance.database.create(json) { id, revision, doc, error in
//
//      if let id = id {
//        let status = ["status": "ok", "id": id]
//        let	result = ["result": status]
//        let json = JSON(result)
//
//        response.status(.OK).send(json: json)
//      } else {
//        let errorMessage = error?.localizedDescription ?? "Unknown error"
//        let status = ["status": "error", "message": errorMessage]
//        let	result = ["result": status]
//        let json = JSON(result)
//
//        response.status(.internalServerError).send(json: json)
//      }
//    }
//  }
//
//  // MAS TODO
//  public func postUpdate(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer { next() }
//
//    guard let values = request.body else {
//      try response.status(.badRequest).end()
//      return
//    }
//
//    // MAS TODO move to shared
//    let allfields = ["id","name","url","architect","imageURL","likes"]
//    var postData = [String: Any]()
//
//    switch ( values ) {
//    case .json(let body):
//      for field in allfields {
//        if let value = body[field].string {
//          postData[field] = value
//          continue
//        }
//        try response.status(.badRequest).end()
//        return
//      }
//
//    case .urlEncoded(let body):
//      for field in allfields {
//        if let value = body[field]?.trimmingCharacters(in: .whitespacesAndNewlines) {
//          if value.characters.count > 0 {
//            postData[field] = value.removingHTMLEncoding()
//            continue
//          }
//        }
//
//        try response.status(.badRequest).end()
//        return
//      }
//    case .multipart(let body):
//      print( " this is a multipart post and is not supported \(body)")
//      try response.status(.badRequest).end()
//    default:
//      try response.status(.badRequest).end()
//    }//end switch
//
//    postData["likes"] = 0
//    let json = JSON(postData)
//
//    SingletonDatastore.sharedInstance.database.create(json) { id, revision, doc, error in
//
//      if let id = id {
//        let status = ["status": "ok", "id": id]
//        let	result = ["result": status]
//        let json = JSON(result)
//
//        response.status(.OK).send(json: json)
//      } else {
//        let errorMessage = error?.localizedDescription ?? "Unknown error"
//        let status = ["status": "error", "message": errorMessage]
//        let	result = ["result": status]
//        let json = JSON(result)
//
//        response.status(.internalServerError).send(json: json)
//      }
//    }
//  }
//
//  // Update an existing model instance or insert a new one in the datastore
//  public func putModel(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer { next() }
//    // MAS TODO Put model ( use the id in the payload )
//  }



}

