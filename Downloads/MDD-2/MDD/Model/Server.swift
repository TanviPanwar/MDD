//
//  Server.swift
//  MDD
//
//  Created by IOS3 on 17/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import SystemConfiguration
import NVActivityIndicatorView
import AVFoundation
import MaterialComponents.MaterialSnackbar
public typealias blockAction = () -> Void
var deviceToken = String()

var todayCheck = true

protocol downloadFileDelegate {
    func showCompletionMsg()
}

protocol updateNameDelegate {
    func updateName()
}


class Server: NSObject ,URLSessionDelegate{

    static let sharedInstance = Server()
    var token = ""
    var userObj = UserModel()
    
    var downlaodDelegate: downloadFileDelegate?
    var updateDelegate : updateNameDelegate?



    private override init() {

    }


    //MARK: - Call API With Parameter

    func uploadImageInMultipart(url: String, image: UIImage , imageParam:String,params: [String: String],completionHandler: @escaping (NSDictionary?, Error?) -> ())  {
        let token = getUserData()

        print(url , params)
        if isInternetAvailable() {
            var r  = URLRequest(url: URL(string: "\(url)")!)
            r.httpMethod = "POST"
            let boundary = "Boundary-\(UUID().uuidString)"
            r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            r.setValue("\(token)", forHTTPHeaderField: "Authorization")
            print("toekn:--\(token)")

            let filename = String( Date().ticks) + ".jpg"

            if image.size != CGSize.zero {

                r.httpBody = createBody(parameters: params,
                                        boundary: boundary,

                                        data:  image.jpegData(compressionQuality: 0.75)!,
                                        mimeType: "image/jpeg",
                                        filename: filename, imageParam: imageParam)
            } else {
                r.httpBody = createBody(parameters: params,
                                        boundary: boundary,
                                        data: Data(),
                                        mimeType: "image/jpeg",
                                        filename: filename, imageParam: imageParam)
            }

            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 50.0
            sessionConfig.timeoutIntervalForResource = 50.0



            let session = URLSession(configuration: sessionConfig)

            //        let session = URLSession.shared
            let task = session.dataTask(with: r as URLRequest) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    completionHandler(nil , error)
                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    DispatchQueue.main.async {
                        completionHandler(nil , error)
                    }


                }


                let responseJSON = try? JSONSerialization.jsonObject(with: data, options:[])
                print(responseJSON)
                if let responseJSON = responseJSON as? NSDictionary {
                    print(responseJSON)
                    DispatchQueue.main.async {
                        completionHandler(responseJSON , nil)
                    }


                }

            }

            task.resume()
        }
        else {
            DispatchQueue.main.async(execute: {
               // Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            })
        }

    }







    func uploadDocInMultipart(url: String, docURL: URL? , docParam:String,params: [String: AnyObject],completionHandler: @escaping (NSDictionary?, Error?) -> ())  {


        print(url , params , docURL)
        if isInternetAvailable() {
            var r  = URLRequest(url: URL(string: "\(url)")!)
            r.httpMethod = "POST"
            let boundary = "Boundary-\(UUID().uuidString)"
            r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            let token = getUserData()
            r.setValue("\(token)", forHTTPHeaderField: "Authorization")
            print("toekn:--\(token)")

            if let docURL = docURL{
                var dataDoc = Data()
                do {
                    dataDoc = try  Data(contentsOf:docURL, options:[])
                    //Data(contentsOf: myURL as URL)

                } catch {
                    print("Unable to load data: \(error)")
                }
                let filename = docURL.lastPathComponent
                let splitName = filename.split(separator: ".")
                let name = String(describing: splitName.first!)
                let filetype = String(describing: splitName.last!)
                r.httpBody = createBody(parameters: params as! [String : String],
                                        boundary: boundary,

                                        data: dataDoc ,
                                        mimeType: filetype,
                                        filename: filename, imageParam: docParam)

            } else {

                r.httpBody = createBody(parameters: params as! [String : String],
                                        boundary: boundary,
                                        data: Data(),
                                        mimeType: "",
                                        filename: "", imageParam: docParam)
            }

            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 50.0
            sessionConfig.timeoutIntervalForResource = 50.0



            let session = URLSession(configuration: sessionConfig)

            //        let session = URLSession.shared
            let task = session.dataTask(with: r as URLRequest) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    completionHandler(nil , error)
                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    DispatchQueue.main.async {
                        completionHandler(nil , error)
                    }


                }


                let responseJSON = try? JSONSerialization.jsonObject(with: data, options:[])
                print(responseJSON)
                if let responseJSON = responseJSON as? NSDictionary {
                    print(responseJSON)
                    DispatchQueue.main.async {
                        completionHandler(responseJSON , nil)
                    }


                }

            }

            task.resume()
        }
        else {
            DispatchQueue.main.async(execute: {
               // Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            })
        }

    }





    func postAPI(url : String , params : [String:AnyObject] , completionHandler: @escaping (NSDictionary?, Error?) -> ()){
        print("URL \(url)")
        print("Parameter \(params)")
     //   let param = "fname=preet&lname=panwar&phoneNumber=8787887987&email=preet@yopmail.com&security_q=5&security_answer=sunita"
        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "POST"
        
        
//        let headers = [
//            "Content-Type": "application/x-www-form-urlencoded"
//        ]
//
//        request.allHTTPHeaderFields = headers
        
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")  // the request is JSON
       request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        

//        let token = getUserData()
//        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
//        print("toekn:--\(token)")
        var stringParameter =   String()



        request.httpBody = try! JSONSerialization.data(withJSONObject: params)       //param.data(using: .utf8)
        let sessionConfig = URLSessionConfiguration.default
        //  sessionConfig.timeoutIntervalForRequest = 50.0
        //  sessionConfig.timeoutIntervalForResource = 50.0
        //request.httpBody = truncate.data(using: .utf8)

        if isInternetAvailable() {
            let session = URLSession(configuration: sessionConfig)
            session.dataTask(with: request) { data, response, error in
                 print("response = \(response)")
                   print("response = \(data)")
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                       // Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }

                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    DispatchQueue.main.async {
                     //   Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }


                }

                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? NSDictionary {
                    print(responseJSON)
                    DispatchQueue.main.async {
                       // Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        completionHandler(responseJSON , nil)
                    }


                }
                else {
                    DispatchQueue.main.async {
                        completionHandler(nil , error)
                       // Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        //                       Server.sharedInstance.showServerError(viewController: UIApplication.topViewController()!)
                    }
                }

                }.resume()


        }
        else {
            DispatchQueue.main.async(execute: {
             //   Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            })
        }



    }



    func postAPIToHandleResponseWithoutDict(url : String , params : [String:AnyObject] , completionHandler: @escaping (NSArray?, Error?) -> ()){
        print("URL \(url)")
        print("Parameter \(params)")


        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let token = getUserData()
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        print("toekn:--\(token)")
        var stringParameter =   String()



        request.httpBody = try! JSONSerialization.data(withJSONObject: params)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 50.0
        sessionConfig.timeoutIntervalForResource = 50.0
        //request.httpBody = truncate.data(using: .utf8)

        if isInternetAvailable() {
            let session = URLSession(configuration: sessionConfig)
            session.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                    //    Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }

                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    DispatchQueue.main.async {
                      //  Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }


                }

                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? NSArray {
                    print(responseJSON)
                    DispatchQueue.main.async {
                      //  Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        completionHandler(responseJSON , nil)
                    }


                }
                else {
                    DispatchQueue.main.async {
                        completionHandler(nil , error)
                       // Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        //                       Server.sharedInstance.showServerError(viewController: UIApplication.topViewController()!)
                    }
                }

                }.resume()


        }
        else {
            DispatchQueue.main.async(execute: {
               // Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            })
        }



    }



    //MARK: - PUT API
    func putAPI(url : String , params : [String:AnyObject] , completionHandler: @escaping (NSDictionary?, Error?) -> ())
    {
        print("URL \(url)")
        print("Parameter \(params)")

        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "PUT"

        request.httpBody = try! JSONSerialization.data(withJSONObject: params)


        request.setValue("application/json", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let token = getUserData()
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        print("toekn:--\(token)")
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 50.0
        sessionConfig.timeoutIntervalForResource = 50.0

        if isInternetAvailable() {
            let session = URLSession(configuration: sessionConfig)
            session.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                     //   Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }

                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    DispatchQueue.main.async {
                      //  Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }


                }

                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? NSDictionary {
                    print(responseJSON)
                    DispatchQueue.main.async {
                     //   Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        completionHandler(responseJSON , nil)
                    }


                }
                else {
                    DispatchQueue.main.async {
                        completionHandler(nil , error)
                     //   Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                        //                       Server.sharedInstance.showServerError(viewController: UIApplication.topViewController()!)
                    }
                }

                }.resume()


        }
        else {
            DispatchQueue.main.async(execute: {
               // Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            })
        }



    }



    func getAPI(url:String,completionHandler:@escaping([String : AnyObject]?,Error?)->Void) {

        print(url)

        if isInternetAvailable() {
            var r  = URLRequest(url: URL(string: "\(url)")!)
            r.httpMethod = "POST"

            let token = getUserData()
            r.setValue("\(token)", forHTTPHeaderField: "Authorization")
            print("toekn:--\(token)")
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 50.0
            sessionConfig.timeoutIntervalForResource = 50.0

            let session = URLSession(configuration: sessionConfig)

            //        let session = URLSession.shared
            let task = session.dataTask(with: r as URLRequest) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    DispatchQueue.main.async { Server.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }
                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    DispatchQueue.main.async {
                        Server.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }


                }


                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                print(responseJSON)
                if let responseJSON = responseJSON as? [String : AnyObject] {
                    print(responseJSON)
                    DispatchQueue.main.async {
                        completionHandler(responseJSON   , nil)
                    }


                }

            }

            task.resume()
        }
    }




    func getApiWithResponseInArray(url:String,completionHandler:@escaping(NSArray?,Error?)->Void)  {

        print(url)


        if isInternetAvailable() {
            var r  = URLRequest(url: URL(string: "\(url)")!)
            r.httpMethod = "GET"

            let token = getUserData()
            r.setValue("\(token)", forHTTPHeaderField: "Authorization")
            print("toekn:--\(token)")
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 50.0
            sessionConfig.timeoutIntervalForResource = 50.0



            let session = URLSession(configuration: sessionConfig)

            //        let session = URLSession.shared
            let task = session.dataTask(with: r as URLRequest) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    DispatchQueue.main.async { Server.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }
                    return
                }

                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    DispatchQueue.main.async {
                        Server.sharedInstance.showServerError(viewController:UIApplication.topViewController()!)
                        completionHandler(nil , error)
                    }


                }


                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? NSArray {
                    print(responseJSON)
                    DispatchQueue.main.async {
                        completionHandler(responseJSON   , nil)
                    }


                }

            }

            task.resume()
        }
    }




    //MARK:- Download File
    func downloadFile(url : String , file : String ,completion: @escaping () -> ()){

        // Create destination URL
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(file)")

        //Create URL to the source file you want to download
        let fileURL = URL(string: url)

        print("fileurl---\(fileURL)**** desturl----\(destinationFileUrl)")

        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        var request = URLRequest(url:fileURL!)
        request.httpMethod = "GET"

        let token = getUserData()
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        print("toekn:--\(token)")

        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }

                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    DispatchQueue.main.async {
                        completion()
                    }

                } catch (let writeError) {
                    print("error writing file \(destinationFileUrl) : \(writeError)")
                    DispatchQueue.main.async {
                        completion()
                    }
                }

            } else {
                print("Failure: %@", error?.localizedDescription);
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
        task.resume()

    }

    
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String , imageParam:String) -> Data {
        let body = NSMutableData()

        let boundaryPrefix = "--\(boundary)\r\n"

        for (key, value) in parameters {

            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(imageParam)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        return body as Data
    }


    //MARK:- Check Internet Connection
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }



    //MARK:- Parse Objects
    func getUserObject(dict:NSDictionary) -> UserModel {

         let name = Server.sharedInstance.checkResponseForString(jsonKey:"Name", dict: dict) as String
        let fname = Server.sharedInstance.checkResponseForString(jsonKey:"firstName", dict: dict) as String
        let lname = Server.sharedInstance.checkResponseForString(jsonKey:"lastName", dict: dict) as String
        let email = Server.sharedInstance.checkResponseForString(jsonKey:"Email", dict: dict) as String
        let phoneNumber = Server.sharedInstance.checkResponseForString(jsonKey:"PhoneNumber", dict: dict) as String
        let security_q = Server.sharedInstance.checkResponseForString(jsonKey:"_id", dict: dict) as String
        let security_answer = Server.sharedInstance.checkResponseForString(jsonKey:"houseNo", dict: dict) as String
        let user_pass = Server.sharedInstance.checkResponseForString(jsonKey:"street", dict: dict) as String
        let old_password = Server.sharedInstance.checkResponseForString(jsonKey:"area", dict: dict) as String
        let new_password = Server.sharedInstance.checkResponseForString(jsonKey:"country", dict: dict) as String
        let security_ans_change = Server.sharedInstance.checkResponseForString(jsonKey:"phone", dict: dict) as String
        let user_id = Server.sharedInstance.checkResponseForString(jsonKey:"UserID", dict: dict) as String
        let token = Server.sharedInstance.checkResponseForString(jsonKey:"token", dict: dict) as String
        let securityQuestion = Server.sharedInstance.checkResponseForString(jsonKey:"security-question", dict: dict) as String
        let questionId = Server.sharedInstance.checkResponseForString(jsonKey:"SecurityQuestion_Id", dict: dict) as String
        
        let loginStatus = Server.sharedInstance.checkResponseForString(jsonKey:"Status", dict: dict) as String
        
        let app_login = Server.sharedInstance.checkResponseForString(jsonKey:"App_login", dict: dict) as String
        
         let firstName = Server.sharedInstance.checkResponseForString(jsonKey:"Firstname", dict: dict) as String
        
         let lastName = Server.sharedInstance.checkResponseForString(jsonKey:"Lastname", dict: dict) as String


        let userObj = UserModel(name: name, fname : fname , lname : lname , phoneNumber : phoneNumber , email : email , security_q : security_q , security_answer : security_answer ,  user_pass : user_pass , old_password : old_password , new_password :  new_password,security_ans_change : security_ans_change , user_id :  user_id , token : token, securityQuestion: securityQuestion, questionId: questionId , loginStatus: loginStatus, App_login: app_login, firstName: firstName, lastName: lastName)

        return userObj
    }


    func getSecurityQuestionsList(array:NSArray) -> [SecurityQuestionsModel] {
        var objects = [SecurityQuestionsModel]()



        for item in array {
            let obj = SecurityQuestionsModel()

            obj.id = Server.sharedInstance.checkResponseForString(jsonKey:"id", dict: item as! NSDictionary) as String
            obj.question = Server.sharedInstance.checkResponseForString(jsonKey:"security-question", dict: item as! NSDictionary) as String

            objects.append(obj)
        }
        return objects
    }



    //MARK:-
    //MARK:- LOADER
    
    func showLoader(){
        let color = UIColor(red: 45/255.0 , green: 211/255.0, blue: 234/255.0, alpha: 1.0)
        let loader = NVActivityIndicatorView(frame: UIApplication.topViewController()!.view.frame , type:NVActivityIndicatorType.ballSpinFadeLoader , color: color, padding:0.0 )
        loader.startAnimating()
        let activityData = ActivityData()
        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
        NVActivityIndicatorView.DEFAULT_TEXT_COLOR = color
        //        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = title as String
        //        NVActivityIndicatorPresenter.sharedInstance.setMessage(title)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        
    }
    
    func showNewLoader(vc: UIViewController){
        let color = UIColor(red: 45/255.0 , green: 211/255.0, blue: 234/255.0, alpha: 1.0)
        let loader = NVActivityIndicatorView(frame: vc.view.frame , type:NVActivityIndicatorType.ballSpinFadeLoader , color: color, padding:0.0 )
        loader.startAnimating()
        let activityData = ActivityData()
        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
        NVActivityIndicatorView.DEFAULT_TEXT_COLOR = color
        //        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = title as String
        //        NVActivityIndicatorPresenter.sharedInstance.setMessage(title)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        
    }
    
    func stopLoader(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
    }
    
    
    

    
    


    //MARK:- EMAIL VALIDATION
    func isEmailValid(email : String) -> Bool{
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: email)
    }

    //MARK:- PASSWORD VALIDATION
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }


    func isPhoneNumValid(phone: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        return result
    }



    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }





    func checkResponseForString(jsonKey : NSString , dict: NSDictionary) -> NSString{
        if((dict.value(forKey: jsonKey as String)) != nil  &&  !(dict.value(forKey: jsonKey as String) is NSNull)){
            if(dict.value(forKey: jsonKey as String) is String){
                var value  = dict.value(forKey: jsonKey as String) as! NSString
                if(value != "NA"){
                    value = convertUnicodeToEmoji(str: value as String) as NSString
                    return value
                }
            }

            else
                if(dict.value(forKey: jsonKey as String) is Int){
                    let value = String(describing:dict.value(forKey: jsonKey as String) as! Int)
                    return "\(value)" as NSString
                }else if(dict.value(forKey: jsonKey as String) is NSNumber){
                    let value = NumberFormatter().string(from:dict.value(forKey: jsonKey as String) as! NSNumber)
                    return value! as NSString
            }

        }
        return ""
    }



    func checkResponseForDict(jsonKey : NSString , dict: NSDictionary) -> String{
        if((dict.value(forKey: jsonKey as String)) != nil  &&  !(dict.value(forKey: jsonKey as String) is NSNull)){
            if  (dict.value(forKey: jsonKey as String) is [NSDictionary]){
                if let parentDict = (dict.value(forKey: jsonKey as String) as? [NSDictionary]){
                    for item in parentDict{
                        for (key,value) in item{
                            if(item.value(forKey: key as! String) is String){
                                return value as! String
                            }
                        }
                    }
                }

            }


        }
        return ""
    }




    func convertUnicodeToEmoji(str : String) -> String{
        let data : NSData = str.data(using: String.Encoding.utf8)! as NSData
        let convertedStr = NSString(data: data as Data, encoding: String.Encoding.nonLossyASCII.rawValue)
        if(convertedStr != nil ){
            return (convertedStr! as String)
        }
        return str
    }
    //MARK:-
    //MARK:- Server Error

    func showServerError(viewController : UIViewController) -> Void {

        let alertController = UIAlertController(title: "Server Error", message: "An error occurred while processing your request.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.cancel, handler: nil))
        viewController.present(alertController, animated: true, completion: nil);
    }



    func gradientLayer(rect:CGRect,colors:[CGColor]) -> CAGradientLayer {
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = rect
        gradientlayer.colors = colors
        return gradientlayer

    }

    func showAlertwithTitle(title:String , desc:String , vc:UIViewController)  {
        let alert = UIAlertController(title: title, message: desc, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    
    
    func showSnackBarAlert(desc: String){
        
        let message = MDCSnackbarMessage()
        message.text = desc
        if UIDevice.current.userInterfaceIdiom == .pad {
        MDCSnackbarManager.messageFont = UIFont.systemFont(ofSize: 30.0)
        }
        MDCSnackbarManager.setBottomOffset(0)
        MDCSnackbarManager.show(message)

        
    }
    
    
    func showSnackBarWithAction(desc: String){

        let message = MDCSnackbarMessage()
        let action = MDCSnackbarMessageAction()
        let actionHandler = {() in
            let answerMessage = MDCSnackbarMessage()
            answerMessage.text = desc
            MDCSnackbarManager.show(answerMessage)
        }
        action.handler = actionHandler
        action.title = "OK"
        action.title = "Cancel"
        message.action = action
        
       
    }
    

    //MARK:- Get Objects From Json





    //MARK:- Compare dates
    func compareDates(msgDate : String) -> String{


        var time = ""
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily

        dateFormatter.timeZone = TimeZone(secondsFromGMT: 19800)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        var date1 = dateFormatter.date(from:"\(msgDate)")!
        // dateFormatter.dateFormat = "dd MMM, yyyy " ; //"dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale --> but no need here

        let dateString = dateFormatter.string(from: date1)
        var  date = dateFormatter.date(from:"\(dateString)")!
        print("EXACT_DATE--- : \(date)")

        let timeInterval = date.timeIntervalSince1970

        let todayDate = Date()

        var result = Calendar.current.compare(todayDate, to: date1, toGranularity: .day)


        if result == .orderedSame {

            time = "Today"
            todayCheck = false
        }else{
            time = ""
            // todayCheck = true
        }

        return "\(time)"
        //\(Utility.convertDateFormateWithTime(date: dateString))"

    }
    
    func checkingResponseForString(jsonKey : NSString , dict: [String:Any]) -> NSString{
        if((dict[jsonKey as String]) != nil  &&  !(dict[ jsonKey as String] is NSNull)){
            if(dict[ jsonKey as String] is String){
                var value  = dict[jsonKey as String] as! NSString
                if(value != "NA"){
                    value = convertUnicodeToEmoji(str: value as String) as NSString
                    return value
                }
            }
                
            else if(dict[ jsonKey as String] is Int){
                let value = String(describing:dict[jsonKey as String] as! Int)
                return "\(value)" as NSString
            }else if(dict[ jsonKey as String] is NSNumber){
                let value = NumberFormatter().string(from:[ jsonKey as String] as! NSNumber)
                return value! as NSString
            }
            
            
        }
        return ""
    }
    
    
    
    func GetQuestionListObjects(array:NSArray) -> [UserModel] {
        var questionArray = [UserModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = UserModel()
            
            obj.security_q = Server.sharedInstance.checkingResponseForString(jsonKey:"security-question" , dict: dict) as String
            obj.question_Id = Server.sharedInstance.checkingResponseForString(jsonKey:"id" , dict: dict) as String
            
            questionArray.append(obj)
        }
        return questionArray
    }
    
    
    func GetCategoryListObjects(array:NSArray) -> [CategoryObjectModel] {
        var categoryArray = [CategoryObjectModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = CategoryObjectModel()
            
            obj.cat_id = Server.sharedInstance.checkingResponseForString(jsonKey:"cat_id" , dict: dict) as String
            obj.cat_name = Server.sharedInstance.checkingResponseForString(jsonKey:"cat_name" , dict: dict) as String
            obj.category_link = Server.sharedInstance.checkingResponseForString(jsonKey:"category_link" , dict: dict) as String
            obj.date = Server.sharedInstance.checkingResponseForString(jsonKey:"date" , dict: dict) as String
            obj.location = Server.sharedInstance.checkingResponseForString(jsonKey:"location" , dict: dict) as String
            obj.image = Server.sharedInstance.checkingResponseForString(jsonKey:"image" , dict: dict) as String
            obj.isCovid = Server.sharedInstance.checkingResponseForString(jsonKey:"is_covid" , dict: dict) as String
            

            categoryArray.append(obj)
        }
        return categoryArray
    }
    
    
    func GetPdfListObjects(array:NSArray) -> [CategoryObjectModel] {
        var pdfArray = [CategoryObjectModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = CategoryObjectModel()
            
            obj.fileUrl = Server.sharedInstance.checkingResponseForString(jsonKey:"file_url" , dict: dict) as String
            obj.postContent = Server.sharedInstance.checkingResponseForString(jsonKey:"post_content" , dict: dict) as String
            obj.title = Server.sharedInstance.checkingResponseForString(jsonKey:"title" , dict: dict) as String
              obj.postUrl = Server.sharedInstance.checkingResponseForString(jsonKey:"post_url" , dict: dict) as String


            pdfArray.append(obj)
        }
        return pdfArray
    }
    
    
    
    
    func GetContactListObjects(array:NSArray) -> [ContactObjectModel] {
        var contactArray = [ContactObjectModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = ContactObjectModel()
            
            obj.designations = Server.sharedInstance.checkingResponseForString(jsonKey:"designations" , dict: dict) as String
            obj.email_address = Server.sharedInstance.checkingResponseForString(jsonKey:"email_address" , dict: dict) as String
            obj.fax_number = Server.sharedInstance.checkingResponseForString(jsonKey:"fax_number" , dict: dict) as String
            obj.image_url = Server.sharedInstance.checkingResponseForString(jsonKey:"image_url" , dict: dict) as String
            obj.more_info = Server.sharedInstance.checkingResponseForString(jsonKey:"more_info" , dict: dict) as String
            obj.phone_number = Server.sharedInstance.checkingResponseForString(jsonKey:"phone_number" , dict: dict) as String
            obj.title = Server.sharedInstance.checkingResponseForString(jsonKey:"title" , dict: dict) as String
            obj.vcard_link = Server.sharedInstance.checkingResponseForString(jsonKey:"vcard_link" , dict: dict) as String
             obj.id = Server.sharedInstance.checkingResponseForString(jsonKey:"id" , dict: dict) as String
            
            contactArray.append(obj)
        }
        return contactArray
    }
    
   
    func GetCategoryOverviewObjects(array:NSArray) -> [CategoryObjectModel] {
        var categoryOverviewArray = [CategoryObjectModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = CategoryObjectModel()
            
            obj.cat_id = Server.sharedInstance.checkingResponseForString(jsonKey:"category_id" , dict: dict) as String
            obj.image = Server.sharedInstance.checkingResponseForString(jsonKey:"category_image" , dict: dict) as String
            obj.cat_name = Server.sharedInstance.checkingResponseForString(jsonKey:"category_name" , dict: dict) as String
            
            
            
            if  let accessable_dirs = dict["description"] as? NSArray {
                
                for i in accessable_dirs {
                    let subobj = CategoryObjectModel()
                    
                    subobj.link_url = Server.sharedInstance.checkingResponseForString(jsonKey:"link" , dict: i as! [String : Any]) as String
                    
                     subobj.title = Server.sharedInstance.checkingResponseForString(jsonKey:"title" , dict: i as! [String : Any]) as String
                    
                      subobj.linkId = Server.sharedInstance.checkingResponseForString(jsonKey:"linkid" , dict: i as! [String : Any]) as String
                   
                    
                    obj.descriptionArray.append(subobj)
                }
                
            }
          
            
            categoryOverviewArray.append(obj)
        }
        return categoryOverviewArray
    }
    
   
    
    func GetNewsFeedListObjects(array:NSArray) -> [CategoryObjectModel] {
        var newsFeedArray = [CategoryObjectModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = CategoryObjectModel()
            
            obj.descriptionText = Server.sharedInstance.checkingResponseForString(jsonKey:"description" , dict: dict) as String
            obj.image = Server.sharedInstance.checkingResponseForString(jsonKey:"image_url" , dict: dict) as String
            obj.link_text = Server.sharedInstance.checkingResponseForString(jsonKey:"link_text" , dict: dict) as String
            obj.link_url = Server.sharedInstance.checkingResponseForString(jsonKey:"link_url" , dict: dict) as String
            obj.title = Server.sharedInstance.checkingResponseForString(jsonKey:"title" , dict: dict) as String
 
            newsFeedArray.append(obj)
        }
        return newsFeedArray
    }
    
    
    func GetObservationGalleryListObjects(array:NSArray) -> [CategoryObjectModel] {
        var galleryArray = [CategoryObjectModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = CategoryObjectModel()
            
            obj.imageCaption = Server.sharedInstance.checkingResponseForString(jsonKey:"image_caption" , dict: dict) as String
            obj.image = Server.sharedInstance.checkingResponseForString(jsonKey:"image_src" , dict: dict) as String

            galleryArray.append(obj)
        }
        return galleryArray
    }
    
    func GetLocationListObjects(array:NSArray) -> [CategoryObjectModel] {
        var locationArray = [CategoryObjectModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = CategoryObjectModel()
            
            obj.location = Server.sharedInstance.checkingResponseForString(jsonKey:"location" , dict: dict) as String
         
            
            locationArray.append(obj)
        }
        return locationArray
    }
    
    
    func GetSearchResultListObjects(array:NSArray) -> [CategoryObjectModel] {
        var searchResultArray = [CategoryObjectModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = CategoryObjectModel()
            
            obj.result = Server.sharedInstance.checkingResponseForString(jsonKey:"result" , dict: dict) as String
            
            
            searchResultArray.append(obj)
        }
        return searchResultArray
    }
    
    
    
    func GetCOVIDSearchResultListObjects(array:NSArray) -> [CategoryObjectModel] {
          var searchResultArray = [CategoryObjectModel]()
          for item in array {
              let dict  = item as!  [String:Any]
              let obj = CategoryObjectModel()
              
              obj.link_text = Server.sharedInstance.checkingResponseForString(jsonKey:"link_name" , dict: dict) as String
            
              obj.link_url = Server.sharedInstance.checkingResponseForString(jsonKey:"link" , dict: dict) as String
              
              
              searchResultArray.append(obj)
          }
          return searchResultArray
      }
    
    
    
    func GetSectorListObjects(array:NSArray) -> [CategoryObjectModel] {
          var searchResultArray = [CategoryObjectModel]()
          for item in array {
              let dict  = item as!  [String:Any]
              let obj = CategoryObjectModel()
              
              obj.industry = Server.sharedInstance.checkingResponseForString(jsonKey:"industry" , dict: dict) as String
            
            if let sectorArray = dict["sector"] as? NSArray , array.count > 0 {
                
                obj.sectorArray = sectorArray as! [String]
                
            }
              
              
              searchResultArray.append(obj)
          }
          return searchResultArray
      }
    
    
    func GetRegionObjects(array:NSArray) -> [CategoryObjectModel] {
          var searchResultArray = [CategoryObjectModel]()
          for item in array {
              let dict  = item as!  [String:Any]
              let obj = CategoryObjectModel()
              
              obj.region = Server.sharedInstance.checkingResponseForString(jsonKey:"region" , dict: dict) as String
              
              
              searchResultArray.append(obj)
          }
          return searchResultArray
      }
    
    
    func GetCountryObjects(array:NSArray) -> [CategoryObjectModel] {
        var searchResultArray = [CategoryObjectModel]()
        for item in array {
            let dict  = item as!  [String:Any]
            let obj = CategoryObjectModel()
            
            obj.country = Server.sharedInstance.checkingResponseForString(jsonKey:"country" , dict: dict) as String
            
            
            searchResultArray.append(obj)
        }
        return searchResultArray
    }
    
    
    
    
    
    func GetNewsFeedObjects(array:NSArray) -> CategoryObjectModel {
        var obj = CategoryObjectModel()
        for item in array {
            let objc = CategoryObjectModel()
            let dict  = item as!  [String:Any]
            
            if let descriptionArray = dict["description"] as? [[String: Any]], descriptionArray.count > 0 {
                
                for item in descriptionArray {
                    
                    
                    let newsObjc =  CategoryObjectModel()
                    
                    newsObjc.title = Server.sharedInstance.checkingResponseForString(jsonKey:"title" , dict: item) as String
                    
                    newsObjc.link_text = Server.sharedInstance.checkingResponseForString(jsonKey:"link" , dict: item) as String
                    
                   obj.descriptionArray.append(newsObjc)
                
                }
                
            }
            
           objc.title = Server.sharedInstance.checkingResponseForString(jsonKey:"other" , dict: dict) as String
            
             objc.link_text = Server.sharedInstance.checkingResponseForString(jsonKey:"other_url" , dict: dict) as String
            
            obj.descriptionArray.append(objc)
            
        }
        return obj
    }
    
    func GetProfileObjects(dict:[String: Any]) -> CategoryObjectModel {
         var obj = CategoryObjectModel()
       
         obj.email = Server.sharedInstance.checkingResponseForString(jsonKey:"email" , dict: dict) as String
        obj.firstName = Server.sharedInstance.checkingResponseForString(jsonKey:"first_name" , dict: dict) as String

        obj.lastName = Server.sharedInstance.checkingResponseForString(jsonKey:"last_name" , dict: dict) as String

          if let array = dict["region"] as? NSArray , array.count > 0 {
            
            obj.regionArray = array as! [String]
            
        }

        
         return obj
     }
    
    
    func GetMonthsIDObjects(array:NSArray) -> [MonthsObject] {
        
        var searchResultArray = [MonthsObject]()
        for item in array {
            
            let dict  = item as!  [String:Any]
            let obj = MonthsObject()
          
            obj.MonthId = Server.sharedInstance.checkResponseForString(jsonKey: "id", dict: dict as NSDictionary) as String
            
            obj.monthName = Server.sharedInstance.checkResponseForString(jsonKey: "name", dict: dict as NSDictionary) as String
            
            searchResultArray.append(obj)
        }
        
        return searchResultArray
        
    }



    //MARK:- Get user token
    func getUserData() -> String{
        var token = ""
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.string(forKey: "TOKEN") {


            token = decoded



        }
        return token
    }


    //END
}

//MARK:- Extensions

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
extension UILabel {

    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }

            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))

            attributedText = attributedString
        }

        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension String {


    func toDouble() -> Double? {
        print((self as NSString).doubleValue)
        return (self as NSString).doubleValue
    }


    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }

    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    func getAttributedText()-> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString(string:self )
        attrStr.addAttribute(NSAttributedString.Key.kern,
                             value: 1.0,
                             range: NSRange(location: 0, length: attrStr.length))
        return attrStr
    }

    func getTrimWhitespaceString() -> String {
        let formattedString = self.replacingOccurrences(of: " ", with: "")

        return formattedString
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

class UIButtonWithSpacing : UIButton
{
    override func setTitle(_ title: String?, for state: UIControl.State)
    {
        if let title = title, spacing != 0
        {
            let color = super.titleColor(for: state) ?? UIColor.black
            let attributedTitle = NSAttributedString(
                string: title,
                attributes: [NSAttributedString.Key.kern: spacing,
                             NSAttributedString.Key.foregroundColor: color])
            super.setAttributedTitle(attributedTitle, for: state)
        }
        else
        {
            super.setTitle(title, for: state)
        }
    }

    fileprivate func updateTitleLabel_()
    {
        let states:[UIControl.State] = [.normal, .highlighted, .selected, .disabled]
        for state in states
        {
            let currentText = super.title(for: state)
            self.setTitle(currentText, for: state)
        }
    }

    @IBInspectable var spacing:CGFloat = 0 {
        didSet {
            updateTitleLabel_()
        }
    }
}

extension UIViewController {
    func setUpCustomTitleView(kerning: CGFloat) {

        let titleLabel = UILabel()

        guard let customFont = UIFont(name: "Roboto-Medium", size: 20) else { return }

        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white ,
                          NSAttributedString.Key.font: customFont,
                          NSAttributedString.Key.kern: kerning] as [NSAttributedString.Key : Any]

        guard let title = title else { return }

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)

        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
}
@IBDesignable
class CustomSlider: UISlider {
    /// custom slider track height
    @IBInspectable var trackHeight: CGFloat = 3

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}
extension UIApplication {
    class func topViewController(_ base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

public class myCustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 3

    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }

    var label: UILabel
    var labelXMin: CGFloat?
    var labelXMax: CGFloat?
    var labelText: ()->String = { "" }

    required public init(coder aDecoder: NSCoder) {
        label = UILabel()
        super.init(coder: aDecoder)!
        self.addTarget(self, action: #selector(onValueChanged(sender:)), for: .valueChanged)

    }
    func setup(){
        labelXMin = frame.origin.x + 16
        labelXMax = frame.origin.x + self.frame.width - 14
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRect(x:labelXPos , y: self.frame.origin.y - 25, width: 200, height: 25)
        label.text = self.value.description

        self.superview!.addSubview(label)

    }
    func updateLabel(){
        label.textColor = UIColor(red: 139/255.0, green:  139/255.0, blue:  139/255.0, alpha: 1.0)
        label.font = UIFont(name:"Roboto", size: 15)
        label.text = labelText()
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRect(x:labelXPos - label.frame.width/2 , y: self.frame.origin.y - 25, width: 200, height: 25)
        label.textAlignment = NSTextAlignment.center
        self.superview!.addSubview(label)
    }
    public override func layoutSubviews() {
        if self.value > 1.0 {
            labelText = {
                "\(Int(self.value))"
                //                String(format: "%.2f", self.value)

            }
        }
        else {
            labelText = {
                String()}
        }
        setup()
        updateLabel()
        super.layoutSubviews()
        super.layoutSubviews()
    }
    @objc func onValueChanged(sender: myCustomSlider){

        updateLabel()
    }
}
extension String {

    var utfData: Data? {
        return self.data(using: .utf8)
    }

    var attributedHtmlString: NSAttributedString? {
        guard let data = self.utfData else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

class DownloadingPopup: UIViewController  {
    @IBOutlet weak var progressViw: UIProgressView!
    @IBOutlet weak var percentageLbl: UILabel!
   // var obj = ImageObject()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressViw.progress = 0.0
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadDidProgress(_:)), name: .downloadProgress, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc  func downloadDidProgress(_ notification: Notification) {
        if let progress = notification.object as? Progress {
            
            if progress.fractionCompleted == 1 {
                
                self.dismiss(animated: true, completion: {
                    
                    Server.sharedInstance.downlaodDelegate?.showCompletionMsg()
   
                })
                
                
              
                
                
                // dismiss/exit
            }
            else {
                
                //self.timeLbl.text = "\(String(describing: progress.estimatedTimeRemaining)) sec"
                self.progressViw.progress = Float(progress.fractionCompleted)
                self.percentageLbl.text = "\(Int(Float(progress.fractionCompleted) * 100)) %"
            }
        }
    }
    
    
    
    
    
}

extension Notification.Name {
    static let downloadProgress = Notification.Name("DownloadProgress")
    static let uploadProgress = Notification.Name("UploadProgress")
    static let uploadMultipleImages = Notification.Name("uploadMultipleImages")
}

