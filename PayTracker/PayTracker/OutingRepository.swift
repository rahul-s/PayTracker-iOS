//
//  OutingRepository.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation

class OutingRepository : NSObject, RepositoryProtocol {
    struct DBTableColumnName {
        //Column names
        static let OutingId = "OutingId"
        static let Title = "Title"
    }
    
    var outingPersonsRepository = OutingPersonsRepository()
    var personRepository = PersonRepository()
    
    static func tableName() -> String {
        return "Outing"
    }
    
    func save(object: BaseModel) -> Bool {
        if let outing = object as? Outing {
            return FMDBImplementation.insert(OutingRepository.tableName(), columnNameValueMap: [DBTableColumnName.OutingId: outing.outingId,
                DBTableColumnName.Title: outing.title], canReplace: true)
        }
        
        return false
    }
    
    func objectWithId(identifier: AnyObject) -> BaseModel? {
        
        if let outingDict = FMDBImplementation.fetchRecordByIdFromTable(OutingRepository.tableName(), identifierKeyValueMap: [DBTableColumnName.OutingId: identifier]) {
            
            return objectFromDictionary(outingDict)
        }
        return nil
    }
    
    func objectFromDictionary(objectDictionary: [String: AnyObject]) -> BaseModel {
        let outing = Outing()
        outing.outingId = objectDictionary[DBTableColumnName.OutingId] as! String
        outing.title = objectDictionary[DBTableColumnName.Title] as? String
        if let outingPersonsIds = outingPersonsRepository.personsForOuting(outing.outingId) {
            
            for personId in outingPersonsIds {
                //get Vehicle object for each vehicleId
                if let person = self.personRepository.objectWithId(personId) {
                    
                    outing.persons.append(person as! Person)
                }
            }
        }

        return outing
    }
}