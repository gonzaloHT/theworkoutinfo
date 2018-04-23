//
//  Exercise.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/4/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import SwiftyJSON

class Exercise : Mappable {
    
    let id: String
    let name: String?
    let description: String?
    var imageURL: String? = nil
    
    required init?(json: JSON) {
        guard let id = json["id"].int else {
            return nil
        }
        
        self.id = "\(id)"
        self.name = json["name"].string
        self.description = json["description"].string
        
        super.init(json: json)
    }
    
}
