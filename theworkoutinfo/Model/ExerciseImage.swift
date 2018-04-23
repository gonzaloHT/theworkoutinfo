//
//  ExerciseImage.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/12/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import SwiftyJSON

class ExerciseImage: Mappable {
    
    var id: Int
    let image: String
    
    required init?(json: JSON) {
        guard let id = json["id"].int, let image = json["image"].string else {
            return nil
        }
        
        self.id = id
        self.image = image
        
        super.init(json: json)
    }
    
}
