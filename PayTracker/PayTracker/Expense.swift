//
//  Expense.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 21/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation
import ObjectMapper

class Expense : BaseModel {
    var expenseId : String!
    var outing : Outing?
    var expenseDescription : String?
    var expenseBy : Person?
    var expenseFor : [Person] = []
    var expenseAmount : Int?
    var note : String?
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map)
        expenseId <- map["ExpenseId"]
        expenseDescription <- map["Decsription"]
        expenseBy <- map["ExpenseBy"]
        expenseFor <- map["ExpenseFor"]
        expenseAmount <- map["ExpenseAmount"]
        note <- map["Note"]
    }
    
    override class func jsonStringToObject(jsonString: String) -> BaseModel? {
        return Mapper<Outing>().map(jsonString)
    }
    
    override class func jsonStringToArrayOfObject(jsonString jsonString: String) -> Array<BaseModel>? {
        return Mapper<Outing>().mapArray(jsonString)
    }
}