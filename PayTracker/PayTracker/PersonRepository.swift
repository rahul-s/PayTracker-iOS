//
//  PersonRepository.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation

class PersonRepository : NSObject, RepositoryProtocol {
    
    struct DBTableColumnName {
        //Column names
        static let PersonId = "PersonId"
        static let Name = "Name"
        static let NickName = "NickName"
        static let Email = "Email"
        static let PhoneNumber = "PhoneNumber"
        static let Password = "Password"
    }
    
    static func tableName() -> String {
        return "Person"
    }
    
    func save(object: BaseModel) -> Bool {
        if let person = object as? Person {
            return FMDBImplementation.insert(PersonRepository.tableName(), columnNameValueMap: [DBTableColumnName.PersonId: person.personId,
                DBTableColumnName.Name: person.name,
                DBTableColumnName.NickName: person.nickName,
                DBTableColumnName.Email: person.email,
                DBTableColumnName.PhoneNumber: person.phoneNumber,
                DBTableColumnName.Password: person.password], canReplace: true)
        }
        
        return false
    }
    
    func objectWithId(identifier: AnyObject) -> BaseModel? {
        
        if let personDict = FMDBImplementation.fetchRecordByIdFromTable(PersonRepository.tableName(), identifierKeyValueMap: [DBTableColumnName.PersonId: identifier]) {
            
            return objectFromDictionary(personDict)
        }
        return nil
    }
    
    func objectFromDictionary(objectDictionary: [String: AnyObject]) -> BaseModel {
        let person = Person()
        person.personId = objectDictionary[DBTableColumnName.PersonId] as! String
        person.name = objectDictionary[DBTableColumnName.Name] as? String
        person.nickName = objectDictionary[DBTableColumnName.NickName] as? String
        person.email = objectDictionary[DBTableColumnName.Email] as? String
        person.phoneNumber = objectDictionary[DBTableColumnName.PhoneNumber] as? String
        person.password = objectDictionary[DBTableColumnName.Password] as? String
        
        return person
    }
}