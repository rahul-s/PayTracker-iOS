//
//  DatabaseProtocol.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation

protocol DatabaseProtocol {
    
    /**
     *  insert or replaces a record in database
     *  @param tableName - name of table in which record is to inserted/replaced.
     *  @param columnNameValueMap - dictionary of columnName mapped to value. Value should be of datatype supported by Sqlite database that can be inserted in a database Column
     *  @param canReplace - Flag indicating if a record can be replaced
     **/
    static func insert(tableName: String, columnNameValueMap: [String: AnyObject?], canReplace: Bool) -> Bool
    
    
    /**
     *  returns nil or a dictionary of the row result mapped to keys of the column names
     *  @param tableName - name of table in the database to read
     *  @param identifierKeyValueMap - Dictionary of identifier name(Column name) mapped to value.
     **/
    static func fetchRecordByIdFromTable(tableName: String, identifierKeyValueMap: [String: AnyObject]) -> [String: AnyObject]?
    
    
    /**
     *  returns nil or an array of dictionary of the row result mapped to keys of the column names
     *  @param tableName - name of table in the database to read
     *  @param keyValueOperatorMapArray - Array of Dictionaries. Each Dictionary contains mapping for Predicates reuired to form the fetch/search query
     {   ColumnName: 'DriverId'
     Value: '12345677'
     Operator: '=', Operator can have values like '<, >, >=, <= !=, ='. This is an optional key value entry since Default operator will be '='
     }
     If this array is empty, method will returns all the records in the table
     **/
    static func fetchRecordsFromTable(tableName: String, withPredicate keyValueOperatorMapArray: [[String: AnyObject]]) -> [[String: AnyObject]]?
    
    
    /**
     *  Delete records from table in database
     *  @param tableName - name of table to delete the records from
     *  @param keyValueOperatorMapArray - Array of Dictionaries. Each Dictionary contains mapping for Predicates reuired to form the fetch/search query
     { ColumnName: 'DriverId'
     Value: '12345677'
     Operator: '=', Operator can have values like '<, >, >=, <= !=, ='. This is an optional key value entry since Default operator will be '='
     }
     If this array is empty, all the records in the table will be deleted
     **/
    static func deleteRecordsFromTable(tableName: String, withPredicate keyValueOperatorMapArray: [[String: AnyObject]]) -> Bool
    
    
    /**
     *  Delete a record from the table with the unique Id
     *  @param tableName - name of table to delete the record from
     *  @param identifierKeyValueMap - Dictionary of identifier name(Column name) mapped to value.
     **/
    static func deleteRecordByIdFromTable(tableName: String, identifierKeyValueMap: [String: AnyObject]) -> Bool
    
    
    /**
     *  returns nil or a dictionary of the row result mapped to keys of the column names
     *  @param query - query to be executed
     *  @param argumentsArray - Array of query argument values
     **/
    static func fetchRecordsForQuery(query: String, argumentsArray: [AnyObject]) -> [[String: AnyObject]]?
    
    
    /**
     *  execute an update query and return the resultValue
     *  @param query - query to be executed
     *  @param argumentsArray - Array of query argument values
     **/
    static func executeUpdateQuery(query: String, argumentsArray: [AnyObject]) -> Bool
    
}