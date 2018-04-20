//
//  Result.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/10/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Result<T> {
    
    case success(T?)
    case error(APIError)
    
}

extension Result where T: Mappable {
    
    init(json: JSON?) {
        if let json = json {
            if let jsonStatus = json["status"].string {
                if (jsonStatus == "success") {
                    self = .success(T(json: json["message"]))
                } else {
                    self = .error(APIError(json: json))
                }
            } else {
                self = .error(APIError(type: .noType))
            }
        }else{
            self = .error(APIError(type: .noType))
        }
    }
    
}
