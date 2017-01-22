
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import DotEnv
//import yachtsShare

HeliumLogger.use()
HeliumLogger.use(.info)

let router = Router()
router.post("/", middleware: BodyParser())

let env = DotEnv()

let api = API()

//let staticService = StaticService()

// ---------------------------------
// static pages and html content
// ---------------------------------

let port = env.getAsInt("APP_PORT") ?? 8090
Kitura.addHTTPServer(onPort: 8090, with: api.router)

// Static Service
//let staticServer = Kitura.addHTTPServer(onPort: 8090, with: staticService.router)

//staticServer.started { [unowned staticService] in
//  staticServer.loadCategories()
//}

Kitura.run()

