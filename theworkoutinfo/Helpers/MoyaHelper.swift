//
//  MoyaHelper.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/9/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

enum APIService {
    case exercises(pageNumber: Int)
    case exerciseImage(exerciseId: String)
}

extension APIService: TargetType {
    
    var path: String {
        switch self {
        case .exercises:
            return "exercise/"
        case .exerciseImage:
            return "exerciseimage/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .exercises, .exerciseImage:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .exercises(pageNumber):
            return .requestParameters(parameters: ["page" : pageNumber], encoding: URLEncoding.default)
        case let .exerciseImage(exerciseId):
            return .requestParameters(parameters: ["exercise" : exerciseId], encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var baseURL: URL {
        return URL(fileURLWithPath: ConfigurationManager.sharedInstance.serverBaseURL)
    }

}
