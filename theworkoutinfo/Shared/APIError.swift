//
//  APIError.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/10/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIError: NSError {
    
    enum ErrorType: String {
        case exerciseNotFound = "Not found"
        case noType = "noType"
    }
    
    static let errorDomain = ConfigurationManager.sharedInstance.serverBaseURL
    static let defaultErrorMessage = "Something went wrong"
    static let defaultErrorCode = -1
    
    var errorType: ErrorType
    
    init() {
        errorType = .noType
        super.init(domain: APIError.errorDomain, code: APIError.defaultErrorCode, userInfo: [NSLocalizedDescriptionKey: APIError.defaultErrorMessage])
    }
    
    init(code: Int? = nil, message: String? ) {
        let errorMessage = message != nil ? message! : APIError.defaultErrorMessage
        let userInfo = [NSLocalizedDescriptionKey: errorMessage]
        let errorCode = code != nil ? code! : APIError.defaultErrorCode
        errorType = .noType
        super.init(domain: APIError.errorDomain, code: errorCode, userInfo: userInfo)
    }
    
    convenience init(json: JSON?) {
        let message = json?["detail"].string ?? ""
        self.init(message: message)
        if let errorTypeString = json?["detail"].string, let errorType = ErrorType.init(rawValue: errorTypeString) {
            self.errorType = errorType
        } else {
            self.errorType = .noType
        }
    }
    
    convenience init (type: ErrorType) {
        self.init()
        errorType = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
