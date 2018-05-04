//
//  ResultCollection.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/10/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ResultCollection<T> {
    
    case success([T])
    case error(APIError)
    
}

extension ResultCollection where T: Mappable {
    
    init(json: JSON?) {
        if let json = json {
            if let results = json["results"].array {
                self = .success(results.flatMap { T.init(json: $0) })
            } else {
                self = .error(APIError(type: .exerciseNotFound))
            }
        } else {
            self = .error(APIError(type: .noType))
        }
    }
    
}
