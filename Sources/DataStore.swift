
import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON
import CouchDB
import yachtsShare

//Singleton version of the datastore
public class SingletonDatastore {

  public var database: Database
  private let databaseName:String
  private let connectionProperties:ConnectionProperties

  static let sharedInstance : Datastore = {
    let host = "localhost"
    let port:Int16 = 5984
    let dbName = "yachts"

    let instance = Datastore(host:host, port:port, dbName:"yachts")
    return instance
  }()

  init(host:String, port:Int16, dbName : String) {
    self.databaseName = dbName
    connectionProperties = ConnectionProperties(host: host, port: port, secured: false)
    let client = CouchDBClient(connectionProperties: connectionProperties)
    database = client.database(databaseName)
  }
}

//instance version
public class Datastore {

  public var database: Database
  private let databaseName:String
  private let connectionProperties:ConnectionProperties

  init(host:String, port:Int16, dbName : String) {
    self.databaseName = dbName
    connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)
    let client = CouchDBClient(connectionProperties: connectionProperties)
    database = client.database(databaseName)
  }
}

