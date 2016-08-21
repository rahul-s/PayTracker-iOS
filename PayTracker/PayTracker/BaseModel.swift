//
//  BaseModel.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ObjectMappable: Mappable {
    func toJSONString() -> String?
    static func jsonStringToObject(jsonString: String) -> BaseModel?
    static func jsonStringToArrayOfObject(jsonString jsonString: String) -> Array<BaseModel>?
}

class BaseModel: NSObject, ObjectMappable {
    
    var identifier: String!
    
    override init() {
        //
    }
    
    required init?(_ map: Map) {
        super.init()
        mapping(map)
    }
    
    func mapping(map: Map) {
        //
    }
    
    class func jsonStringToObject(jsonString: String) -> BaseModel? {
        return Mapper<BaseModel>().map(jsonString)
    }
    
    class func jsonStringToArrayOfObject(jsonString jsonString: String) -> Array<BaseModel>? {
        return Mapper<BaseModel>().mapArray(jsonString)
    }
    
    func toJSONString() -> String? {
        return Mapper().toJSONString(self, prettyPrint: true)
    }
}
