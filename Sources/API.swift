
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

  lazy var router: Router = {

    let router = Router()
    router.post("/", middleware: BodyParser())
    
    API.addService(model:ModelYacht.self, router: router, serviceRoot:"/yachts", dbName: "yachts")
    API.addService(model:ModelArchitect.self, router: router, serviceRoot:"/architects", dbName: "architects")
    API.addService(model:ModelUser.self, router: router, serviceRoot:"/users", dbName: "users")

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


}


//    // ---------------------------
//    // Yachts Route
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
