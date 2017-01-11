
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import yachtsShare

// yacht model extension
extension Yacht {
  func serialize() -> JSON {
    let model:[String: Any] = serialize()
    let json = JSON(model)
    return json
  }
}

class YachtService {

  lazy var database: Database = {
    let dbName = "yachts"
    let connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)
    let client = CouchDBClient(connectionProperties: connectionProperties)
    let database = client.database(dbName)
    return database

  }()
  
  lazy var router: Router = {
    let router = Router()

    router.post("/", middleware: BodyParser())
    router.get("/yachts", handler: self.getAllModels)     // GetAll
    router.get("/yacht/:id", handler: self.getModel)      // Get
    //router.post("/yacht/:id", handler: self.updateModel)  // Update , MAS TODO

    router.post("/yachtNew", handler: self.createModel)   // function Create
    router.get("/yachtLike/:id", handler: self.incrimentLike)    // function Like with Get

    return router
  }()

  func getAllModels(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
    defer { next() }

    database.retrieveAll(includeDocuments: true) { docs, error in
      if let error = error {
        let errorMessage = error.localizedDescription
        let status = ["status": "error", "message": errorMessage]
        let	result = ["result": status]
        let json = JSON(result)
        response.status(.notFound).send(json: json)
      } else if let docs = docs {

        //      let total_rows = docs["total_rows"].stringValue
        //      let offset = docs["offset"].stringValue
        //      Log.info("total_rows: \(total_rows)")
        //      Log.info("offset: \(offset)")

        let status = ["status": "ok"]
        var models = [Yacht]()

        for (index,doc) in docs["rows"].arrayValue.enumerated() {
          var dictionary = [String: Any]()
          dictionary["id"] = doc["id"].stringValue
          dictionary["name"] = doc["doc"]["name"].stringValue
          dictionary["url"] = doc["doc"]["url"].stringValue
          dictionary["architect"] = doc["doc"]["architect"].stringValue
          dictionary["likes"] = doc["doc"]["like"].intValue
          dictionary["imageURL"] = doc["doc"]["imageURL"].stringValue

          let m = Yacht.deserialize(dictionary: dictionary)
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

    database.retrieve(yacht) { doc, error in

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
        dictionary["url"] = doc["url"].stringValue
        dictionary["architect"] = doc["architect"].stringValue
        dictionary["likes"] = doc["like"].intValue
        dictionary["imageURL"] = doc["imageURL"].stringValue

        let model = Yacht.deserialize(dictionary: dictionary)

        let result: [String: Any] = ["result": status, "data": model.serialize() as [String:Any] ]
        let json = JSON(result)
        response.status(.OK).send(json: json)
      }
    }
  }

  // post, create new
  func createModel(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
    defer { next() }

    guard let values = request.body else {
      try response.status(.badRequest).end()
      return
    }

    guard case .urlEncoded(let body) = values else {
      try response.status(.badRequest).end()
      return
    }

    let fields = ["name", "architect", "url"]
    var yacht = [String: Any]()

    for field in fields {
      if let value = body[field]?.trimmingCharacters(in: .whitespacesAndNewlines) {
        if value.characters.count > 0 {
          yacht[field] = value.removingHTMLEncoding()
          continue
        }
      }

      try response.status(.badRequest).end()
      return
    }

    yacht["likes"] = 0
    let json = JSON(yacht)

    database.create(json) { id, revision, doc, error in

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

  func updateModel(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
    defer { next() }

    guard let id = request.parameters["id"] else {
      response.status(.badRequest).send("Missing model ID.")
      return
    }

    //
    //    guard var fields = request.getPost(fields: ["title", "strap", "content", "category", "slug"]) else {
    //      response.status(.badRequest).send("Missing required fields.")
    //      return
    //    }
    //
    //    let (db, connection) = try connectToDatabase()
    //    let categoryQuery = "SELECT `id` FROM `categories` WHERE `name` = ?"
    //
    //    if let categoryID = db.singleQuery(categoryQuery, [fields["category"]!], connection)?.int {
    //      fields["category"] = String(categoryID)
    //    } else {
    //      response.status(.badRequest).send("Unknown category.")
    //      return
    //    }
    //
    //    let query: String
    //    var orderedFields = [fields["title"]!, fields["strap"]!, fields["content"]!, fields["category"]!, fields["slug"]!]
    //
    //    if storyID == "create" {
    //      query = "INSERT INTO `posts` (`title`, `strap`, `content`, `category`, `slug`, `date`) VALUES (?, ?, ?, ?, ?, NOW());"
    //    } else {
    //      query = "UPDATE `posts` SET `title` = ?, `strap` = ?, `content` = ?, `category` = ?, `slug` = ? WHERE `id` = ?;"
    //      orderedFields.append(storyID)
    //    }
    //
    //    do {
    //      _ = try db.execute(query, orderedFields, connection)
    //
    //      let result = ["status": "ok"]
    //      response.status(.OK).send(json: JSON(result))
    //    } catch {
    //      response.status(.notFound).send("Unknown story ID.")
    //      return
    //    }

  }

  // like a specific yacht
  func incrimentLike(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
    defer { next() }

    guard let id = request.parameters["id"] else {
        try response.status(.badRequest).end()
        return
    }

    database.retrieve(id) { doc, error in
      if let error = error {
        let errorMessage = error.localizedDescription
        let status = ["status": "error", "message": errorMessage]
        let	result = ["result": status]
        let json = JSON(result)

        response.status(.notFound).send(json: json)
        //next()
      } else if let doc = doc {
        var newDocument = doc
        let id = doc["_id"].stringValue
        let rev = doc["_rev"].stringValue

        newDocument["likes"].intValue = 3

        self.database.update(id, rev: rev, document: newDocument) { rev, doc, error in
          if let error = error {
            let status = ["status": "error"]
            let	result = ["result": status]
            let json = JSON(result)
            response.status(.conflict).send(json: json)
          } else {
            let status = ["status": "ok"]
            let	result = ["result": status]
            let json = JSON(result)
            response.status(.OK).send(json: json)
          }
        }
      }
    }
  }

  func getfunction(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
    defer { next() }
    //response.status(.OK).send(json: JSON(categoryNames))
    response.status(.OK).send("Not yet implimented")
  }

}

