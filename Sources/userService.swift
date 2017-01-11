
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import yachtsShare

class UserService {

  lazy var database: Database = {
    let dbName = "users"
    let connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)
    let client = CouchDBClient(connectionProperties: connectionProperties)
    let database = client.database(dbName)
    return database

  }()

  lazy var router: Router = {
    let router = Router()

    router.post("/", middleware: BodyParser())
    router.get("/users", handler: self.getAllModels)     // GetAll
    router.get("/user/:id", handler: self.getModel)      // Get
    //router.post("/user/:id", handler: self.updateModel)  // Update , MAS TODO
    //router.post("/userNew", handler: self.createModel)   // function Create

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


  
}
