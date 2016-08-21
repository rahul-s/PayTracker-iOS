//
//  OutingPersons.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation

class OutingPersonsRepository : NSObject, RepositoryProtocol {
    struct DBTableColumnName {
        //Column names
        static let OutingId = "OutingId"
        static let PersonId = "PersonId"
    }
    
    static func tableName() -> String {
        return "OutingPersons"
    }
    
    func save(outingId:String, personId:String) -> Bool {
        return FMDBImplementation.insert(OutingPersonsRepository.tableName(), columnNameValueMap: [DBTableColumnName.OutingId: outingId,
            DBTableColumnName.PersonId: personId], canReplace: true)
    }
    
    func personsForOuting(outingId:String) -> [String]? {
        var personIds: [String]?
        if let results = FMDBImplementation.fetchRecordsFromTable(OutingPersonsRepository.tableName(), withPredicate: [[FMDBImplementation.QueryParameterMapKey.ColumnName: DBTableColumnName.OutingId,
            FMDBImplementation.QueryParameterMapKey.Value: outingId]]) {
            
            for resultDict in results {
                
                if personIds == nil {
                    personIds = [String]()
                }
                personIds?.append(resultDict[DBTableColumnName.PersonId] as! String)
            }
        }
        
        return personIds
    }
    
    func deletePersonsForOuting(outingId:String) -> Bool {
        return FMDBImplementation.deleteRecordsFromTable(OutingPersonsRepository.tableName(), withPredicate: [[FMDBImplementation.QueryParameterMapKey.ColumnName: DBTableColumnName.OutingId,
            FMDBImplementation.QueryParameterMapKey.Value: outingId]])
    }
}