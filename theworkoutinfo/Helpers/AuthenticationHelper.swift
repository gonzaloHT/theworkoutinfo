//
//  AuthenticationHelper.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 3/21/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation

class AuthenticationHelper {
    
    class func getUserCredentials() -> AuthenticationManager.AuthenticationCredentials {
        return AuthenticationManager.AuthenticationCredentials(email: "test", password: "test1234")
    }
    
}
