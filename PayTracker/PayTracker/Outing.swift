//
//  Outing.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation
import ObjectMapper

class Outing : BaseModel {
    var outingId : String!
    var title : String?
    var owner : Person?
    var persons : [Person] = []
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map)
        outingId <- map["OutingId"]
        title <- map["Title"]
        owner <- map["Owner"]
        persons <- map["OutingPersons"]
    }
    
    override class func jsonStringToObject(jsonString: String) -> BaseModel? {
        return Mapper<Outing>().map(jsonString)
    }
    
    override class func jsonStringToArrayOfObject(jsonString jsonString: String) -> Array<BaseModel>? {
        return Mapper<Outing>().mapArray(jsonString)
    }
}