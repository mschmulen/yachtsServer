
import Foundation
//import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
//import CouchDB
//import yachtsShare

class StaticService {

  func yack() {
    Log.info("Static Service")
  }

//  lazy var router: Router = {
//    let router = Router()
//
//    //router.post("/", middleware: BodyParser())
//    router.get("/static", handler: StaticFileServer())
//    router.get("/contact", handler: self.getContact)
//
//    return router
//  }()
//
//  func getContact(request: RouterRequest, response: RouterResponse, next: () -> Void) throws {
//    defer { next() }
//    response.send("Get in touch with us about swift")
//  }

  //router.all("/static", middleware: StaticFileServer())
  //
  //router.get("/") { request, response, next in
  //  response.send("<html>")
  //  response.send("<body>")
  //  response.send("<h1>Welcome to the swift Server</h1>")
  //  response.send("</body>")
  //  response.send("</html>")
  //
  //  next()
  //}
  //
  //router.get("/contact") { request, response, next in
  //  response.send("Get in touch with us about swift")
  //  next()
  //}

}



