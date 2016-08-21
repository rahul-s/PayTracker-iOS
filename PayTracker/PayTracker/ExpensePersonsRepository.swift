//
//  ExpensePersonsRepository.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation

class ExpensePersonsRepository: NSObject, RepositoryProtocol {
    struct DBTableColumnName {
        //Column names
        static let ExpenseId = "ExpenseId"
        static let PersonId = "PersonId"
    }
    
    static func tableName() -> String {
        return "ExpensePersons"
    }
    
    func save(expenseId:String, personId:String) -> Bool {
        return FMDBImplementation.insert(ExpensePersonsRepository.tableName(), columnNameValueMap: [DBTableColumnName.ExpenseId: expenseId,
            DBTableColumnName.PersonId: personId], canReplace: true)
    }
    
    func personsForExpense(expenseId:String) -> [String]? {
        var personIds: [String]?
        if let results = FMDBImplementation.fetchRecordsFromTable(ExpensePersonsRepository.tableName(), withPredicate: [[FMDBImplementation.QueryParameterMapKey.ColumnName: DBTableColumnName.ExpenseId,
            FMDBImplementation.QueryParameterMapKey.Value: expenseId]]) {
            
            for resultDict in results {
                
                if personIds == nil {
                    personIds = [String]()
                }
                personIds?.append(resultDict[DBTableColumnName.PersonId] as! String)
            }
        }
        
        return personIds
    }
    
    func deletePersonsForExpense(expenseId:String) -> Bool {
        return FMDBImplementation.deleteRecordsFromTable(ExpensePersonsRepository.tableName(), withPredicate: [[FMDBImplementation.QueryParameterMapKey.ColumnName: DBTableColumnName.ExpenseId,
            FMDBImplementation.QueryParameterMapKey.Value: expenseId]])
    }

}