//
//  ExerciseCategory.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 5/2/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import SwiftyJSON

class ExerciseCategory : Mappable {
    
    let id: Int
    let name: String
    
    required init?(json: JSON) {
        guard let id = json["id"].int, let name = json["name"].string else {
            return nil
        }
        
        self.id = id
        self.name = name
        
        super.init(json: json)
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        
        super.init()
    }
    
}
