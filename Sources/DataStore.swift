
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
  private let connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)

  static let sharedInstance : Datastore = {
    let instance = Datastore(dbName:"yachts")
    return instance
  }()

  init( dbName : String) {
    self.databaseName = dbName
    let client = CouchDBClient(connectionProperties: connectionProperties)
    database = client.database(databaseName)
  }
}

//instance version
public class Datastore {

  public var database: Database
  private let databaseName:String
  private let connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)

  init( dbName : String) {
    self.databaseName = dbName
    let client = CouchDBClient(connectionProperties: connectionProperties)
    database = client.database(databaseName)
  }
}

