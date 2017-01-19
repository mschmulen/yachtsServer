
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import DotEnv
import yachtsShare

//Singleton version of the datastore
public class SingletonDatastore {

  public var database: Database
  private let databaseName:String
  private let connectionProperties:ConnectionProperties

  static let sharedInstance : Datastore = {
    //let host = "localhost"
    //let port:Int16 = 5984
    let dbName = "yachts"
    let instance = Datastore(dbName:"yachts")
    return instance
  }()

  init(dbName : String) {
    self.databaseName = dbName

    let env = DotEnv()
    connectionProperties = ConnectionProperties(
      host: env.get("DB_HOST") ?? "localhost",
      port: Int16(env.getAsInt("DB_PORT") ?? 5984),
      secured: env.getAsBool("DB_HTTPS") ?? false,
      username: env.get("DB_USERNAME") ?? "matt",
      password: env.get("DB_PASSWORD") ?? "123456"
    )
    let client = CouchDBClient(connectionProperties: connectionProperties)
    database = client.database(databaseName)
  }
}

//instance version
public class Datastore {

  public var database: Database
  private let databaseName:String
  private let connectionProperties:ConnectionProperties

  init(dbName : String) {

    let env = DotEnv()
    connectionProperties = ConnectionProperties(
      host: env.get("DB_HOST") ?? "localhost",
      port: Int16(env.getAsInt("DB_PORT") ?? 5984),
      secured: env.getAsBool("DB_HTTPS") ?? false,
      username: env.get("DB_USERNAME") ?? "matt",
      password: env.get("DB_PASSWORD") ?? "123456"
    )

    self.databaseName = dbName
    //connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)
    let client = CouchDBClient(connectionProperties: connectionProperties)
    database = client.database(databaseName)
  }
}

