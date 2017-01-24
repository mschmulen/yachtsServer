
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB

import yachtsShare

// conform the model object to a CRUDModel

extension ModelYacht : CRUDModel { }
extension ModelUser : CRUDModel { }
extension ModelArchitect : CRUDModel { }

class API {

  let version = "v1"

  lazy var router: Router = {

    let router = Router()

    router.post("/", middleware: BodyParser())

    // Add generic CRUD service endpoints
    API.addService(model:ModelYacht.self, router: router, serviceRoot:"/yachts", dbName: "yachts")
    API.addService(model:ModelArchitect.self, router: router, serviceRoot:"/architects", dbName: "architects")
    API.addService(model:ModelUser.self, router: router, serviceRoot:"/users", dbName: "users")
    
    // Add some custom service endpoints

    router.get("/version", handler: { (request, response, next: @escaping () -> Void) in
      defer { next() }
      let status = ["status": "ok"]
      let result: [String: Any] = ["result": status, "app":"yachtsServer", "version": "1.1.0"]
      let json = JSON(result)
      response.status(.OK).send(json: json)
    })

    API.addRegisterService(router: router)
    API.addLikeService(router: router)

    return router

  }()

  static func addService<T:CRUDModel>(model:T.Type, router:Router, serviceRoot:String, dbName:String) {

    let serviceDataStore = Datastore(dbName: dbName)
    let service = ServiceGenericModelCRUD<T>()
    service.dataStore = {
      return serviceDataStore
    }

    // Find all instances matched by filter from the datastore
    router.get(serviceRoot, handler: service.getAll)

    // Create a new instance of the model and persist it in the datastore
    router.post(serviceRoot, handler: service.postCreate)
    
    // Update an existing model instance or insert a new one in the datastore
    router.put(serviceRoot, handler: service.putModel)

    // Update attributes for a model instance and persist in the datastore
    router.put("\(serviceRoot)/:id", handler:  service.putUpdateModel)

    // HEAD , check if the model instance exists in the datastore
    //    router.head("\(serviceRoot)/:id", handler:  service.headExists)

    // find a model instance by id from the datastore
    router.get("\(serviceRoot)/:id", handler:  service.getModel)

    // delete a model instance by id from the datastore
    router.delete("\(serviceRoot)/:id", handler:  service.deleteModel)

    // check if the model instance exists in the datastore
    //    router.get("\(serviceRoot)/:id/exists", handler:  service.getExists)

    // count instances of the model matched by where from the datastore
    //        router.get("\(serviceRoot)/:id/count", handler:  service.getCount)

    // find the first instance of the model matched by filter from the datastore
    //        router.get("\(serviceRoot)/findOne", handler:  service.getFindOne)

    // update instances of the model matched by where from the datastore
    router.post("\(serviceRoot)/update", handler:  service.postUpdate)

    // custom method
    router.get("\(serviceRoot)/:id", handler: service.incrimentLike)
  }

  static func addLikeService(router: Router) {

    router.post("/like", handler: { (request, response, next: @escaping () -> Void) in
      defer { next() }

      guard let id = request.parameters["id"] else {
        try response.status(.badRequest).end()
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

          newDocument["likes"].intValue = 3

          SingletonDatastore.sharedInstance.database.update(id, rev: rev, document: newDocument) { rev, doc, error in
            if let _ = error {
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
    })
  }
  
  static func addRegisterService(router:Router) {

    router.post("/register", handler: { (request, response, next: @escaping () -> Void) in
      defer { next() }

      guard let values = request.body else {
        try response.status(.badRequest).end()
        return
      }

      let requiredPostfields = ["name", "email", "password"]
      var postData = [String: Any]()

      var email:String? = ""
      switch ( values ) {
      case .json(let body) :
        for field in requiredPostfields {
          if let value = body[field].string {
            postData[field] = value
            continue
          }
          try response.status(.badRequest).end()
          return
        }

        email = body["email"].string

      case .urlEncoded(let body) :
        for field in requiredPostfields {
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
        print( " this is a multipart post and is not supported \(body)")
        try response.status(.badRequest).end()
      default:
        try response.status(.badRequest).end()
      }//end switch

      let status = ["status": "ok", "email": email]
      let	result = ["result": status]
      response.status(.OK).send(json: JSON(result))
    })
  }





}


//    // ---------------------------
//    // Legacy Yachts Route
//    // ---------------------------
//    let yachtDataStore = Datastore(dbName: "yachts")
//    let yachtService = YachtService()
//    yachtService.dataStore = {
//      return yachtDataStore
//    }
//
//    // Find all instances matched by filter from the datastore
//    router.get("/yachts", handler: yachtService.getAll)
//
//    // Create a new instance of the model and persist it in the datastore
//    router.post("/yachts", handler: yachtService.postCreate)
//
//    // Update an existing model instance or insert a new one in the datastore
//    router.put("/yachts", handler: yachtService.putModel)
//
//    // Update attributes for a model instance and persist in the datastore
//    router.put("/yachts/:id", handler:  yachtService.putUpdateModel)
//
//    // HEAD , check if the model instance exists in the datastore
////    router.head("/yachts/:id", handler:  yachtService.headExists)
//
//    // find a model instance by id from the datastore
//    router.get("/yachts/:id", handler:  yachtService.getModel)
//
//    // delete a model instance by id from the datastore
//    router.delete("/yachts/:id", handler:  yachtService.deleteModel)
//
//    // check if the model instance exists in the datastore
////    router.get("/yachts/:id/exists", handler:  yachtService.getExists)
//
//    // count instances of the model matched by where from the datastore
////        router.get("/yachts/:id/count", handler:  yachtService.getCount)
//
//    // find the first instance of the model matched by filter from the datastore
////        router.get("/yachts/findOne", handler:  yachtService.getFindOne)
//
//    // update instances of the model matched by where from the datastore
//    router.post("/yacht/update", handler:  yachtService.postUpdate)
//
//    // custom method
//    router.get("/yachtLike/:id", handler: yachtService.incrimentLike)
//
//    // ---------------------------
//    // Users Route
//    // ---------------------------
//    let userDataStore = Datastore(dbName: "users")
//    let userService = UserService()
//    userService.dataStore = {
//      return userDataStore
//    }
//
//    //Find all instances matched by filter from the datastore
//    router.get("/users", handler: userService.getAll)
//
//    //find a model instance by id from the datastore
//    router.get("/users/:id", handler:  userService.getModel)
//
//    // delete a model instance by id from the datastore
//    router.delete("/users/:id", handler:  userService.deleteModel)
//
//    // Create a new instance of the model and persist it in the datastore
//    router.post("/users", handler: userService.postCreate)
