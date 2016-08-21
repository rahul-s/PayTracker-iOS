//
//  ExpenseRepository.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation

class ExpenseRepository : NSObject, RepositoryProtocol {
    struct DBTableColumnName {
        //Column names
        static let ExpenseId = "ExpenseId"
        static let OutingId = "OutingId"
        static let Amount = "Amount"
        static let ExpenseByPersonId = "ExpenseByPersonId"
        static let Description = "Description"
        static let Note = "Note"
    }
    
    var outingRepository = OutingRepository()
    var personRepository = PersonRepository()
    //var expensePersonsRepository = OutingPersonsRepository()
    
    static func tableName() -> String {
        return "Expense"
    }
    
    func save(object: BaseModel) -> Bool {
        if let expense = object as? Expense {
            return FMDBImplementation.insert(ExpenseRepository.tableName(), columnNameValueMap: [DBTableColumnName.ExpenseId: expense.expenseId,
                DBTableColumnName.OutingId: expense.outing?.outingId,
                DBTableColumnName.Amount: expense.expenseAmount,
                DBTableColumnName.ExpenseByPersonId: expense.expenseBy?.personId,
                DBTableColumnName.Description: expense.expenseDescription,
                DBTableColumnName.Note: expense.note], canReplace: true)
        }
        
        return false
    }
    
    func objectWithId(identifier: AnyObject) -> BaseModel? {
        
        if let outingDict = FMDBImplementation.fetchRecordByIdFromTable(ExpenseRepository.tableName(), identifierKeyValueMap: [DBTableColumnName.OutingId: identifier]) {
            
            return objectFromDictionary(outingDict)
        }
        return nil
    }
    
    func objectFromDictionary(objectDictionary: [String: AnyObject]) -> BaseModel {
        let expense = Expense()
        expense.expenseId = objectDictionary[DBTableColumnName.ExpenseId] as! String
        if let outingId = objectDictionary[DBTableColumnName.OutingId] as? String {
            expense.outing = self.outingRepository.objectWithId(outingId) as? Outing
        }
        if let personId = objectDictionary[DBTableColumnName.ExpenseByPersonId] as? String {
            expense.expenseBy = self.personRepository.objectWithId(personId) as? Person
        }
//        if let outingPersonsIds = expensePersonsRepository.personsForOuting(<#T##outingId: String##String#>) {
//            
//            for vehicleId in vehicleIdArray {
//                //get Vehicle object for each vehicleId
//                if let vehicle = vehicleRepository.objectWithId(vehicleId) {
//                    
//                    driver.vehicles.append(vehicle as! Vehicle)
//                }
//            }
//        }
        expense.expenseAmount = objectDictionary[DBTableColumnName.Amount] as? Int
        expense.expenseDescription = objectDictionary[DBTableColumnName.Description] as? String
        expense.note = objectDictionary[DBTableColumnName.Note] as? String
        
        return expense
    }
}