
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
//import yachtsShare

// yacht model extension
//extension Yacht {
//  func serialize() -> JSON {
//    let model:[String: Any] = serialize()
//    let json = JSON(model)
//    return json
//  }
//}

//public class YachtService {
//
//  private typealias Model = Yacht
////  private typealias Model = ModelYacht
//
//  var dataStore: (()-> Datastore)?
//
//  // MAS NOTE: why was next allowed as non marked @escaping ... apply the next inside the datastore retrieve closure
//  //Find all instances matched by filter from the datastore
//  public func getAll(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer {
//      Log.info("defer next")
//      next()
//    }
//
//    Log.info("start func")
//
//
//    SingletonDatastore.sharedInstance.database.retrieveAll(includeDocuments: true) { docs, error in
//      if let error = error {
//        let errorMessage = error.localizedDescription
//        let status = ["status": "error", "message": errorMessage]
//        let	result = ["result": status]
//        let json = JSON(result)
//        response.status(.notFound).send(json: json)
//        //next()
//      } else if let docs = docs {
//
//        //      let total_rows = docs["total_rows"].stringValue
//        //      let offset = docs["offset"].stringValue
//        //      Log.info("total_rows: \(total_rows)")
//        //      Log.info("offset: \(offset)")
//
//        let status = ["status": "ok"]
//        var models = [Model]()
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
////          let m = Model.deserialize(dictionary: dictionary)
//          let anyDictionary = dictionary as Any
//          let m = Model(object: anyDictionary)
//          models.append(m)
//        }
//
//        var outDictionary = [[String: Any]]()
//        for model in models {
////          outDictionary.append(model.serialize())
//          outDictionary.append(model.dictionaryRepresentation())
//        }
//
//        Log.info("pre result response")
//
//        let result: [String: Any] = ["result": status, "data": outDictionary]
//        let json = JSON(result)
//        response.status(.OK).send(json: json)
//        //next()
//
//      }
//    }
//    Log.info("end of func")
//
//  }
//
//  // find a model instance by id from the datastore
//  public func getModel(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer { next() }
//
//    guard let id = request.parameters["id"] else {
//      response.status(.badRequest).send("Missing id")
//      return
//    }
//
//    SingletonDatastore.sharedInstance.database.retrieve(id) { doc, error in
//      if let error = error {
//        let errorMessage = error.localizedDescription
//        let status = ["status": "error", "message": errorMessage]
//        let	result = ["result": status]
//        let json = JSON(result)
//
//        response.status(.notFound).send(json: json)
//      } else if let doc = doc {
//        let status = ["status": "ok"]
//
//        var dictionary = [String: Any]()
//        dictionary["id"] = doc["_id"].stringValue
//        dictionary["name"] = doc["name"].stringValue
//        dictionary["url"] = doc["url"].stringValue
//        dictionary["architect"] = doc["architect"].stringValue
//        dictionary["likes"] = doc["like"].intValue
//        dictionary["imageURL"] = doc["imageURL"].stringValue
//
//        //let model = Yacht.deserialize(dictionary: dictionary)
//        let anyDictionary = dictionary as Any
//        let model = Model(object: anyDictionary)
//
//        //let result: [String: Any] = ["result": status, "data": model.serialize() as [String:Any] ]
//        let result: [String: Any] = ["result": status, "data": model.dictionaryRepresentation() as [String:Any] ]
//        let json = JSON(result)
//        response.status(.OK).send(json: json)
//      }
//    }
//    //next()
//  }
//
//  // delete a model instance by id from the datastore
//  public func deleteModel(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer { next() }
//
//    guard let id = request.parameters["id"] else {
//      response.status(.badRequest).send("Missing id")
//      return
//    }
//
//    SingletonDatastore.sharedInstance.database.retrieve(id) { doc, error in
//      if let error = error {
//        let errorMessage = error.localizedDescription
//        let status = ["status": "error", "message": errorMessage]
//        let	result = ["result": status]
//        let json = JSON(result)
//
//        response.status(.notFound).send(json: json)
//        //next()
//      } else if let doc = doc {
////        var newDocument = doc
//        let id = doc["_id"].stringValue
//        let rev = doc["_rev"].stringValue
//
//        SingletonDatastore.sharedInstance.database.delete(id, rev: rev) { error in
//          if let error = error {
//            let errorMessage = error.localizedDescription
//            let status = ["status": "error", "message": errorMessage]
//            let	result = ["result": status]
//            let json = JSON(result)
//            response.status(.notFound).send(json: json)
//          } else {
//            let status = ["status": "ok"]
//            let result: [String: Any] = ["result": status, "message": "instance \(id) deleted" ]
//            let json = JSON(result)
//            response.status(.OK).send(json: json)
//          }
//        }
//      }//end if let doc
//    }//end retrieve by id so as to get a revision number
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
//
//  public func putUpdateModel(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer { next() }
//
//    guard let id = request.parameters["id"] else {
//      response.status(.badRequest).send("Missing model ID.")
//      return
//    }
//
//    Log.info("id \(id)")
//
//    //
//    //    guard var fields = request.getPost(fields: ["title", "strap", "content", "category", "slug"]) else {
//    //      response.status(.badRequest).send("Missing required fields.")
//    //      return
//    //    }
//    //
//    //    let (db, connection) = try connectToDatabase()
//    //    let categoryQuery = "SELECT `id` FROM `categories` WHERE `name` = ?"
//    //
//    //    if let categoryID = db.singleQuery(categoryQuery, [fields["category"]!], connection)?.int {
//    //      fields["category"] = String(categoryID)
//    //    } else {
//    //      response.status(.badRequest).send("Unknown category.")
//    //      return
//    //    }
//    //
//    //    let query: String
//    //    var orderedFields = [fields["title"]!, fields["strap"]!, fields["content"]!, fields["category"]!, fields["slug"]!]
//    //
//    //    if storyID == "create" {
//    //      query = "INSERT INTO `posts` (`title`, `strap`, `content`, `category`, `slug`, `date`) VALUES (?, ?, ?, ?, ?, NOW());"
//    //    } else {
//    //      query = "UPDATE `posts` SET `title` = ?, `strap` = ?, `content` = ?, `category` = ?, `slug` = ? WHERE `id` = ?;"
//    //      orderedFields.append(storyID)
//    //    }
//    //
//    //    do {
//    //      _ = try db.execute(query, orderedFields, connection)
//    //
//    //      let result = ["status": "ok"]
//    //      response.status(.OK).send(json: JSON(result))
//    //    } catch {
//    //      response.status(.notFound).send("Unknown story ID.")
//    //      return
//    //    }
//
//  }
//  
//  // custom method
//  
//  public func getfunction(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer { next() }
//    response.status(.OK).send("Not yet implimented")
//  }
//
//}

