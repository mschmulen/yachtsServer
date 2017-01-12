
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import yachtsShare

HeliumLogger.use()
HeliumLogger.use(.info)

let router = Router()
router.post("/", middleware: BodyParser())

let api = API()
//let yachtService = YachtService()
//let userService = UserService()
//let staticService = StaticService()

// ---------------------------------
// static pages and html content
// ---------------------------------

//Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.addHTTPServer(onPort: 8090, with: api.router)
//Kitura.addHTTPServer(onPort: 8090, with: yachtService.router)
//Kitura.addHTTPServer(onPort: 8090, with: userService.router)

// Static Service
//let staticServer = Kitura.addHTTPServer(onPort: 8090, with: staticService.router)

//staticServer.started { [unowned staticService] in
//  staticServer.loadCategories()
//}

Kitura.run()

