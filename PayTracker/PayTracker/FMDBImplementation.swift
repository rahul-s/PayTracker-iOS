//
//  FMDBImplementation.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation
import FMDB


class FMDBImplementation: NSObject, DatabaseProtocol {
    
    struct QueryParameterMapKey {
        static let ColumnName = "ColumnName"
        static let Value = "Value"
        static let Operator = "Operator"
    }
    
    //MARK: DatabaseProtocol methods
    static func insert(tableName: String, columnNameValueMap: [String: AnyObject?], canReplace: Bool) -> Bool {
        
        //Form a query string to insert object in db
        let keysString = columnNameValueMap.keys.joinWithSeparator(",")
        
        var valueStringArray:Array = Array<String>()
        for _ in columnNameValueMap.keys {
            valueStringArray.append("?")
        }
        let valuesString = valueStringArray.joinWithSeparator(",")
        
        let dbOperation = canReplace ? "REPLACE" : "INSERT"
        
        let query = "\(dbOperation) INTO \(tableName) (\(keysString)) VALUES (\(valuesString))"
        
        //Create arguments array
        var argumentsArray = [AnyObject]()
        for value in columnNameValueMap.values {
            argumentsArray.append(value ?? NSNull())
        }
        
        let isSaved = DatabaseManager.getSharedInstance().executeUpdate(query, argumentsArray: argumentsArray)
        
        return isSaved
    }
    
    
    static func fetchRecordByIdFromTable(tableName: String, identifierKeyValueMap: [String: AnyObject]) -> [String: AnyObject]? {
        
        var keyValueOperatorMapArray = [[String: AnyObject]]()
        for key in identifierKeyValueMap.keys {
            
            keyValueOperatorMapArray.append([QueryParameterMapKey.ColumnName: key,
                QueryParameterMapKey.Value: identifierKeyValueMap[key]!] )
        }
        
        if let results = FMDBImplementation.fetchRecordsFromTable(tableName, withPredicate: keyValueOperatorMapArray) {
            return results[0];
        }
        return nil
    }
    
    
    static func fetchRecordsFromTable(tableName: String, withPredicate keyValueOperatorMapArray: [[String: AnyObject]]) -> [[String: AnyObject]]? {
        
        let queryPredicate = FMDBImplementation.queryPredicateFromKeyValueOperatorMap(keyValueOperatorMapArray)
        
        let query = "SELECT * FROM \(tableName)" + (queryPredicate.whereClause ?? "")
        
        let resultSet: FMResultSet = DatabaseManager.getSharedInstance().executeSelect(query, argumentsArray: queryPredicate.argumentsArray)
        
        return FMDBImplementation.resultsArrayFromQueryResultSet(resultSet)
    }
    
    
    
    static func deleteRecordsFromTable(tableName: String, withPredicate keyValueOperatorMapArray: [[String: AnyObject]]) -> Bool {
        
        let queryPredicate = FMDBImplementation.queryPredicateFromKeyValueOperatorMap(keyValueOperatorMapArray)
        
        let query = "DELETE FROM \(tableName)" + (queryPredicate.whereClause ?? "")
        
        return  DatabaseManager.getSharedInstance().executeUpdate(query, argumentsArray: queryPredicate.argumentsArray)
    }
    
    
    
    static func deleteRecordByIdFromTable(tableName: String, identifierKeyValueMap: [String: AnyObject]) -> Bool {
        
        var keyValueOperatorMapArray = [[String: AnyObject]]()
        for key in identifierKeyValueMap.keys {
            
            keyValueOperatorMapArray.append([QueryParameterMapKey.ColumnName: key,
                QueryParameterMapKey.Value: identifierKeyValueMap[key]!] )
        }
        return  deleteRecordsFromTable(tableName, withPredicate: keyValueOperatorMapArray)
    }
    
    
    static func fetchRecordsForQuery(query: String, argumentsArray: [AnyObject]) -> [[String: AnyObject]]? {
        
        let resultSet: FMResultSet = DatabaseManager.getSharedInstance().executeSelect(query, argumentsArray: argumentsArray)
        
        return FMDBImplementation.resultsArrayFromQueryResultSet(resultSet)
    }
    
    
    static func executeUpdateQuery(query: String, argumentsArray: [AnyObject]) -> Bool {
        
        return  DatabaseManager.getSharedInstance().executeUpdate(query, argumentsArray: argumentsArray)
    }
    
    
    //MARK: Private methods
    static func resultsArrayFromQueryResultSet(resultSet: FMResultSet) -> [[String: AnyObject]]? {
        
        //Loop to each row for result set
        var resultsArray: [[String: AnyObject]]?
        while (resultSet.next()) {
            
            if resultsArray == nil {
                resultsArray = [[String: AnyObject]]()
            }
            resultsArray?.append(resultSet.resultDictionary() as! [String: AnyObject])
        }
        return resultsArray
    }
    
    
    static func queryPredicateFromKeyValueOperatorMap(keyValueOperatorMapArray: [[String: AnyObject]]) -> (whereClause:String, argumentsArray: [AnyObject]) {
        
        var whereClause: String?
        //Create arguments array
        var argumentsArray = [AnyObject]()
        
        //form the search query
        for (index, keyValueOperatorDict) in keyValueOperatorMapArray.enumerate() {
            
            if whereClause == nil {
                whereClause = " WHERE"
            }
            
            //Read the comparison operator from dictionary
            var compareOperator: String!
            if let operatorValue =  keyValueOperatorDict[QueryParameterMapKey.Operator]{
                compareOperator = operatorValue as! String
            }
            else {
                //Default operator is '='
                compareOperator = "="
            }
            
            whereClause = whereClause! + " \(keyValueOperatorDict[QueryParameterMapKey.ColumnName]!) \(compareOperator) ?"
            
            if index < keyValueOperatorMapArray.count - 1 {
                whereClause = whereClause! + " AND"
            }
            
            //populate arguments array with the search values
            argumentsArray.append(keyValueOperatorDict[QueryParameterMapKey.Value]!)
            
        }
        
        return(whereClause ?? "", argumentsArray)
    }
    
}