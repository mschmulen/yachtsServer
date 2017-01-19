
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import yachtsShare

class API {

  lazy var router: Router = {

    let userDataStore = Datastore(dbName: "users")
    let userService = UserService()
    userService.dataStore = {
      return userDataStore
    }

    //currently the yachts sevice uses a singleton datastore , im not sure which I like the best so Im going to try both for a little while and see how it sorts out
    let yachtService = YachtService()



    let router = Router()
    router.post("/", middleware: BodyParser())

    // ---------------------------
    // Yachts Route
    // ---------------------------

    // Find all instances matched by filter from the datastore
    router.get("/yachts", handler: yachtService.getAll)

    // Create a new instance of the model and persist it in the datastore
    router.post("/yachts", handler: yachtService.postCreate)

    // Update an existing model instance or insert a new one in the datastore
    router.put("/yachts", handler: yachtService.putModel) // formerly .updateModel)

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
//        router.post("/yacht/update", handler:  yachtService.postUpdate)

    // custom method
    router.get("/yachtLike/:id", handler: yachtService.incrimentLike)

    // ---------------------------
    // Users Route
    // ---------------------------

    //Find all instances matched by filter from the datastore
    router.get("/users", handler: userService.getAll)     // GetAll

    //find a model instance by id from the datastore
    router.get("/users/:id", handler:  userService.getModel)

    // delete a model instance by id from the datastore
    router.delete("/users/:id", handler:  userService.deleteModel)

    // Create a new instance of the model and persist it in the datastore
    router.post("/users", handler: userService.postCreate)


    return router
  }()


}
