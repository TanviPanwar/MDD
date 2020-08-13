//
//  SecurityQuestionsModel.swift
//  MDD
//
//  Created by IOS3 on 20/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import Foundation



class SecurityQuestionsModel: NSObject , NSCoding {


    var id = String()
    var question = String()



    init(id : String , question : String ) {

        self.id = id
        self.question = question

    }


    override init() {
        super.init()
    }


    required convenience init(coder aDecoder: NSCoder) {

        let id = aDecoder.decodeObject(forKey: "id") as! String
        let question = aDecoder.decodeObject(forKey: "question") as! String


        self.init(id : id , question : question)
    }


    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(question, forKey: "question")

    }


}

