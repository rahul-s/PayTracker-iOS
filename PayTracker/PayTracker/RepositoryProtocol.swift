//
//  RepositoryProtocol.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation

@objc protocol RepositoryProtocol {
    
    //Save BaseModel object to a persistent database. Also saves the custom objects to respective tables in the database
    optional func save(object: BaseModel) -> Bool
    
    //Return nil or BaseModel class Object for the unique 'identifier' reading from a DB
    optional func objectWithId(identifier: AnyObject) -> BaseModel?
    
    //Return Table Name where the object details will be saved
    static func tableName() -> String
    
    //Delete object record from the database. Also delete the associated records in other tables if any
    optional func deleteObject(object: BaseModel) -> Bool
}