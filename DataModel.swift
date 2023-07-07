//
//  DataModel.swift
//  CrudTask
//
//  Created by trioangle on 07/07/23.
//

import Foundation

struct DataModel: Codable {
    let id: String
    let name, email, mobile: String
    let gender: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case mobile
        case gender
    }
    
    init() {
        self.id = ""
        self.name = ""
        self.email = ""
        self.mobile = ""
        self.gender = ""
    }
}
