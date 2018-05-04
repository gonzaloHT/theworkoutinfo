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
    case exerciseImage(exerciseId: String)
    case exercisesByCategory(categoryId: Int?, pageNumber: Int)
    case exerciseCategories
}

extension APIService: TargetType {
    
    var path: String {
        switch self {
        case .exercisesByCategory:
            return "exercise/"
        case .exerciseImage:
            return "exerciseimage/"
        case .exerciseCategories:
            return "exercisecategory"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .exerciseImage, .exercisesByCategory, .exerciseCategories:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .exerciseImage(exerciseId):
            return .requestParameters(parameters: ["exercise" : exerciseId], encoding: URLEncoding.default)
        case let .exercisesByCategory(categoryId, pageNumber):
            var parameters: [String: Any] = ["page": pageNumber]
            if let id = categoryId {
                parameters["category"] = id
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .exerciseCategories:
            return .requestPlain
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
