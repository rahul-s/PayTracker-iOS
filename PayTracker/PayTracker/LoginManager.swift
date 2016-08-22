//
//  LoginManager.swift
//  PayTracker
//
//  Created by Rahul Shettigar on 22/08/16.
//  Copyright © 2016 Rahul Shettigar. All rights reserved.
//

import Foundation

class LoginManager : NSObject {
    
    static let keyLoggedInUserId = "LoggedInUserId"
    
    static var sharedInstance : LoginManager!
    
    let personRepository = PersonRepository()
    
    class func getSharedInstance() -> LoginManager {
        self.sharedInstance = self.sharedInstance ?? LoginManager()
        return self.sharedInstance
    }
    
    var loggedInUserId : String? {
        get {
            //fetch from NSUserDefaults
            let userId = NSUserDefaults.standardUserDefaults().valueForKey(LoginManager.keyLoggedInUserId) as! String?
            return userId
        }
        set {
            //save to NSUserDefaults
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: LoginManager.keyLoggedInUserId)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
}

//MARK: - public methods
extension LoginManager {
    func isLoggedIn() -> Bool {
        return false
    }
    
    func registerUser(name:String, nickName:String?, phoneNumber:String, email:String?, password:String?, completion:(status:Bool) -> Void) {
        let person = Person();
        person.personId = NSUUID().UUIDString
        person.name = name
        person.nickName = nickName
        person.email = email
        person.phoneNumber = phoneNumber
        person.password = password
        completion(status: personRepository.save(person))
    }
}