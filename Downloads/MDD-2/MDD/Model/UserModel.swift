//
//  UserModel.swift
//  MDD
//
//  Created by IOS3 on 20/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import Foundation



class UserModel: NSObject , NSCoding {

    var name = String()
    var fname = String()
    var lname = String()
    var phoneNumber = String()
    var email = String()
    var security_q = String()
    var security_answer = String()
    var user_pass = String()
    var old_password = String()
    var new_password =  String()
    var security_ans_change = String()
    var user_id =  String()
    var token = String()
    var question_Id = String()
    var security_question = String()
    var loginStatus = String()
    var App_login = String()
    var firstName = String()
    var lastName = String()



    
    init(name:String, fname : String , lname : String , phoneNumber : String , email : String , security_q : String , security_answer : String ,  user_pass : String , old_password : String , new_password :  String,security_ans_change : String , user_id :  String , token : String, securityQuestion: String, questionId: String, loginStatus: String, App_login: String, firstName: String, lastName: String ) {

         self.name = name
         self.fname = fname
         self.lname = lname
         self.phoneNumber = phoneNumber
         self.email = email
         self.security_q = security_q
         self.security_answer = security_answer
         self.user_pass = user_pass
         self.old_password = old_password
         self.new_password = new_password
         self.security_ans_change = security_ans_change
         self.user_id = user_id
         self.token = token
         self.security_question = securityQuestion
         self.question_Id = questionId
         self.loginStatus = loginStatus
         self.App_login = App_login
         self.firstName = firstName
         self.lastName = lastName

    }


    override init() {
        super.init()
    }


    required convenience init(coder aDecoder: NSCoder) {

        let name = aDecoder.decodeObject(forKey: "Name") as! String
        let fname = aDecoder.decodeObject(forKey: "fname") as! String
        let lname = aDecoder.decodeObject(forKey: "lname") as! String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let security_q = aDecoder.decodeObject(forKey: "security_q") as! String
        let security_answer = aDecoder.decodeObject(forKey: "security_answer") as! String
        let user_pass = aDecoder.decodeObject(forKey: "user_pass") as! String
        let old_password = aDecoder.decodeObject(forKey: "old_password") as! String
        let new_password = aDecoder.decodeObject(forKey: "new_password") as! String
        let security_ans_change = aDecoder.decodeObject(forKey: "security_ans_change") as! String
        let user_id = aDecoder.decodeObject(forKey: "user_id") as! String
        let token = aDecoder.decodeObject(forKey: "token") as! String
        let securityQuestion = aDecoder.decodeObject(forKey: "security-question") as! String
        let questionId = aDecoder.decodeObject(forKey: "SecurityQuestion_Id") as! String
        let loginStatus = aDecoder.decodeObject(forKey: "Status") as! String
        let App_login = aDecoder.decodeObject(forKey: "App_login") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String






        self.init(name: name , fname : fname , lname : lname , phoneNumber : phoneNumber , email : email , security_q : security_q , security_answer : security_answer ,  user_pass : user_pass , old_password : old_password , new_password :  new_password,security_ans_change : security_ans_change , user_id :  user_id , token : token, securityQuestion: securityQuestion, questionId: questionId, loginStatus: loginStatus, App_login : App_login, firstName : firstName, lastName : lastName)
    }


    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(fname, forKey: "fname")
        aCoder.encode(lname, forKey: "lname")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(security_q, forKey: "security_q")
        aCoder.encode(security_answer, forKey: "security_answer")
        aCoder.encode(user_pass, forKey: "user_pass")
        aCoder.encode(old_password, forKey: "old_password")
        aCoder.encode(new_password, forKey: "new_password")
        aCoder.encode(security_ans_change, forKey: "security_ans_change")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(security_question, forKey: "security")
        aCoder.encode(question_Id, forKey: "SecurityQuestion_Id")
        aCoder.encode(loginStatus, forKey: "Status")
        aCoder.encode(App_login, forKey: "App_login")
        aCoder.encode(App_login, forKey: "firstName")
        aCoder.encode(App_login, forKey: "lastName")



    }


}
