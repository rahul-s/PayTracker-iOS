//
//  Person.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation
import ObjectMapper

class Person : BaseModel {
    
    var personId : String!
    var name : String?
    var nickName : String?
    var email : String?
    var phoneNumber : String?
    var password : String?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map)
        personId <- map["AddressId"]
        name <- map["Location"]
        nickName <- map["Address1"]
        email <- map["Address2"]
        phoneNumber <- map["City"]
        password <- map["State"]
    }
    
    override class func jsonStringToObject(jsonString: String) -> BaseModel? {
        return Mapper<Person>().map(jsonString)
    }
    
    override class func jsonStringToArrayOfObject(jsonString jsonString: String) -> Array<BaseModel>? {
        return Mapper<Person>().mapArray(jsonString)
    }
}