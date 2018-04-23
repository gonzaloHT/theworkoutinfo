//
//  RequestHelper.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/6/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

typealias RequestCompletionHandler = (_ json: JSON, _ error: Error?) -> ()

class RequestHelper {
    
    let disposeBag = DisposeBag()
    
    static let sharedInstance = RequestHelper()
    
    fileprivate var provider: MoyaProvider<APIService>
    
    init() {
        provider = MoyaProvider<APIService>()
    }
    
    func performRequest<T: Mappable>(service: APIService) -> Observable<Result<T>> {
        return provider.rx.request(service).map { response -> Result<T> in
            Result(json: JSON(response.data))
            }.asObservable()
    }
    
    func performRequestCollection<T: Mappable>(service: APIService) -> Observable<ResultCollection<T>> {
        return provider.rx.request(service).map { response -> ResultCollection<T> in
            ResultCollection(json: JSON(response.data))
            }.asObservable()
    }
    
}
