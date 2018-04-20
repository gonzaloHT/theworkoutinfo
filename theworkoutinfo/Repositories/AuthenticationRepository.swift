//
//  AuthenticationRepository.swift
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

class AuthenticationRepository {
    
    struct AuthenticationCredentials: Equatable {
        let email: String
        let password: String
        
        static func ==(lhs: AuthenticationRepository.AuthenticationCredentials, rhs: AuthenticationRepository.AuthenticationCredentials) -> Bool {
            return (lhs.email == rhs.email) && (lhs.password == rhs.password)
        }
    }
    
    static let sharedInstance = AuthenticationRepository()
    
    var trySigning: AnyObserver<AuthenticationCredentials>
    var signInResult: Observable<LoginResult>
    
    init() {
        let _trySigning = PublishSubject<AuthenticationCredentials>()
        trySigning = _trySigning.asObserver()
        signInResult = _trySigning.asObservable().map { (authCredentials) -> LoginResult in
            let userCredentials = AuthenticationRepository.getUserCredentials()
            let result: LoginResult
            let credentialsOk = authCredentials == userCredentials
            credentialsOk ? (result = LoginResult.success) : (result = LoginResult.wrongCredentials)
            UserDefaults.standard.set(credentialsOk, forKey: "isUserLoggedIn")
            return result
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
    
    //This method is just for test the app and simulate a user Log in request
    class func getUserCredentials() -> AuthenticationCredentials {
        return AuthenticationCredentials(email: "test", password: "test1234")
    }
    
    class func logout() {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
    }
    
}
