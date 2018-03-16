//
//  ConfigurationManager+Properties.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 3/15/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation

extension ConfigurationManager {
    
    static var environment: Environment {
        return Environment(rawValue: ConfigurationManager.currentConfiguration as! String)!
    }
    
    var serverBaseURL: String {
        return configs["SERVER_BASE_URL"]!
    }
    
}
