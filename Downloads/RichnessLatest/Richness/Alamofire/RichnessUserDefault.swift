//
//  QuickServeUserDefault.swift
//  QuickSereve
//
//  Created by Sobura on 2/2/2018.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation

class RichnessUserDefault:NSObject{
    
    class func set(key:String,value:Bool){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func get(key:String) -> Bool{
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
    
    class func setString(key:String,value:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getString(key:String) -> String{
        let value = UserDefaults.standard.string(forKey: key) ?? ""
        return value
    }
    
    class func setInt(key:String,value:Int){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getInt(key:String) -> Int{
        let value = UserDefaults.standard.integer(forKey: key)
        return value
    }
    
    class func setUserID(val : String)
    {
        setString(key: "userId", value: val)
    }
    
    class func  getUserID() -> String
    {
        return getString(key: "userId")
    }
    
    class func setOtherUserID(val : String)
    {
        setString(key: "otheruserid", value: val)
    }
    
    class func  getOtherUserID() -> String
    {
        return getString(key: "otheruserid")
    }
    
    class func setUserRanking(val : String)
    {
        setString(key: "ranking", value: val)
    }
    
    class func  getUserRanking() -> String
    {
        return getString(key: "ranking")
    }
    
    class func setFirstUser(val : Bool)
    {
        set(key: "firstuser", value: val)
    }
    
    class func getFirstUser() -> Bool
    {
        return get(key: "firstuser")
    }
}
