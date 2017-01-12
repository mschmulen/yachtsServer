
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
    //currently the yachts sevice uses a singleton datastore , im not sure which I like the best so Im going to try both for a little while and see how it sorts out

    let yachtService = YachtService()

    let userService = UserService()
    userService.dataStore = {
      return userDataStore
    }

    let router = Router()

    //Yachts Route
    router.post("/", middleware: BodyParser())
    router.get("/yachts", handler: yachtService.getAllModels )
    router.get("/yacht/:id", handler:  yachtService.getModel)      // Get
    //router.post("/yacht/:id", handler: self.yachtService.updateModel)  // Update , MAS TODO
    router.get("/yachtLike/:id", handler: yachtService.incrimentLike)    // function Like with Get
    router.post("/yachtNew", handler: yachtService.createModel)   // function Create

    //Users Route
    //router.post("/", middleware: BodyParser())
    router.get("/users", handler: userService.getAllModels)     // GetAll
    router.get("/user/:id", handler: userService.getModel)      // Get
    
    return router
  }()


}
