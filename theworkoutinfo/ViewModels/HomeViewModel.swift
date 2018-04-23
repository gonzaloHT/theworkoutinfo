//
//  HomeViewModel.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/4/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    let tryLogout: AnyObserver<Void>
    let loadExercises: AnyObserver<Void>
    
    //MARK: - Outputs
    
    let didLogout: Observable<Void>
    
    var exercises: Observable<[Exercise]> {
        return _exercisesVariable.asObservable()
    }
    
    var error: Observable<String> {
        return _error.asObservable()
    }
    
    //MARK: Properties
        
    private let _error = PublishSubject<String>()
    private let _exercisesVariable = Variable<[Exercise]>([])
    
    init() {
        let _tryLogout = PublishSubject<Void>()
        tryLogout = _tryLogout.asObserver()
        
        didLogout = _tryLogout.asObservable().map({
            AuthenticationRepository.logout()
        })
        
        let _loadExercises = PublishSubject<Void>()
        loadExercises = _loadExercises.asObserver()
        
        _loadExercises.asObservable().flatMap({ _ in
            ContentRepository.sharedInstance.getExercisesWithImages()
        }).map({ [weak self] resultCollection -> [Exercise] in
            switch resultCollection {
            case .success(let exercises):
                return exercises
            case .error(let error):
                self?._error.asObserver().onNext(error.errorType.rawValue)
                return []
            }
        }).bind(to: _exercisesVariable).disposed(by: disposeBag)
    }
    
}
