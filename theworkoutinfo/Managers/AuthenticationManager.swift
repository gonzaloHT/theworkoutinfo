//
//  AuthenticationManager.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 3/21/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import RxSwift

enum LoginResult {
    case success
    case wrongCredentials
}

class AuthenticationManager {
    
    struct AuthenticationCredentials: Equatable {
        let email: String
        let password: String
        
        static func ==(lhs: AuthenticationManager.AuthenticationCredentials, rhs: AuthenticationManager.AuthenticationCredentials) -> Bool {
            return (lhs.email == rhs.email) && (lhs.password == rhs.password)
        }
    }
    
    static let sharedInstance = AuthenticationManager()
    
    var trySigning: AnyObserver<AuthenticationCredentials>
    var signInResult: Observable<LoginResult>
    
    init() {
        let _trySigning = PublishSubject<AuthenticationCredentials>()
        trySigning = _trySigning.asObserver()
        signInResult = _trySigning.asObservable().map { (authCredentials) -> LoginResult in
            let userCredentials = AuthenticationHelper.getUserCredentials()
            let result: LoginResult
            let credentialsOk = authCredentials == userCredentials
            credentialsOk ? (result = LoginResult.success) : (result = LoginResult.wrongCredentials)
            return result
        }
    }
    
}
