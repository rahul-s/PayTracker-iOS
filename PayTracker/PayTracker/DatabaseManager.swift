//
//  DatabaseManager.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation
import FMDB

class DatabaseManager: NSObject {
    
    let kDatabaseFilename = "PayTrackerDB.sqlite"
    
    static var sharedInstance: DatabaseManager!
    
    var database:FMDatabase!
    
    static func getSharedInstance() -> DatabaseManager {
        
        self.sharedInstance = self.sharedInstance ?? DatabaseManager()
        return self.sharedInstance
    }
    
    override init() {
        
        super.init()
        
        //Setup database
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        let databasePath = documentsDirectoryPath.stringByAppendingPathComponent(kDatabaseFilename)
        
        print("Database path:\(databasePath)")
        
        if NSFileManager.defaultManager().fileExistsAtPath(databasePath) {
            self.database = FMDatabase(path: databasePath)
        }
        else {
            if let defaultDBPath  = NSBundle.mainBundle().pathForResource((kDatabaseFilename as NSString).stringByDeletingPathExtension , ofType: (kDatabaseFilename as NSString).pathExtension) {
                do {
                    try NSFileManager.defaultManager().copyItemAtPath(defaultDBPath, toPath: databasePath)
                } catch {
                    // Handle Error
                    self.database = nil
                }
                self.database=FMDatabase(path: databasePath)
                
            }
        }
        
        self.database.open()
    }
    
    
    deinit{
        database.close()
    }
    
    
    
    // MARK: Query
    func executeSelect(selectStatement:String, argumentsArray:[AnyObject]) -> FMResultSet {
        let resultSet:FMResultSet = database.executeQuery(selectStatement, withArgumentsInArray: argumentsArray)
        return resultSet
    }
    
    func executeUpdate(updateStatement:String, argumentsArray:[AnyObject]) -> Bool {
        let status = database.executeUpdate(updateStatement, withArgumentsInArray: argumentsArray)
        return status
    }
    
}