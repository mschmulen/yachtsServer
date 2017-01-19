
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import yachtsShare

class API {

  lazy var router: Router = {

    let router = Router()
    router.post("/", middleware: BodyParser())

    // ---------------------------
    // Yachts Route
    // ---------------------------
    let yachtDataStore = Datastore(dbName: "yachts")
    let yachtService = YachtService()
    yachtService.dataStore = {
      return yachtDataStore
    }

    // Find all instances matched by filter from the datastore
    router.get("/yachts", handler: yachtService.getAll)

    // Create a new instance of the model and persist it in the datastore
    router.post("/yachts", handler: yachtService.postCreate)

    // Update an existing model instance or insert a new one in the datastore
    router.put("/yachts", handler: yachtService.putModel)

    // Update attributes for a model instance and persist in the datastore
    router.put("/yachts/:id", handler:  yachtService.putUpdateModel)

    // HEAD , check if the model instance exists in the datastore
//    router.head("/yachts/:id", handler:  yachtService.headExists)

    // find a model instance by id from the datastore
    router.get("/yachts/:id", handler:  yachtService.getModel)

    // delete a model instance by id from the datastore
    router.delete("/yachts/:id", handler:  yachtService.deleteModel)

    // check if the model instance exists in the datastore
//    router.get("/yachts/:id/exists", handler:  yachtService.getExists)

    // count instances of the model matched by where from the datastore
//        router.get("/yachts/:id/count", handler:  yachtService.getCount)

    // find the first instance of the model matched by filter from the datastore
//        router.get("/yachts/findOne", handler:  yachtService.getFindOne)

    // update instances of the model matched by where from the datastore
    router.post("/yacht/update", handler:  yachtService.postUpdate)

    // custom method
    router.get("/yachtLike/:id", handler: yachtService.incrimentLike)

    // ---------------------------
    // Users Route
    // ---------------------------
    let userDataStore = Datastore(dbName: "users")
    let userService = UserService()
    userService.dataStore = {
      return userDataStore
    }

    //Find all instances matched by filter from the datastore
    router.get("/users", handler: userService.getAll)

    //find a model instance by id from the datastore
    router.get("/users/:id", handler:  userService.getModel)

    // delete a model instance by id from the datastore
    router.delete("/users/:id", handler:  userService.deleteModel)

    // Create a new instance of the model and persist it in the datastore
    router.post("/users", handler: userService.postCreate)

    return router
  }()


}
