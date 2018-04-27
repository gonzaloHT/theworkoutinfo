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
    let loadExercises: AnyObserver<Int>
    let selectExercise: AnyObserver<Exercise>
    
    //MARK: - Outputs
    
    let didLogout: Observable<Void>
    let didSelectExercise: Observable<Exercise>
    var exercises: Observable<[Exercise]> {
        return _exercisesVariable.asObservable()
    }
    
    var error: Observable<String> {
        return _error.asObservable()
    }
    
    //MARK: - Properties
        
    private let _error = PublishSubject<String>()
    private let _exercisesVariable = Variable<[Exercise]>([])
    private let page = Variable<Int>(1)
    
    init() {
        let _tryLogout = PublishSubject<Void>()
        tryLogout = _tryLogout.asObserver()
        
        didLogout = _tryLogout.asObservable().map({
            AuthenticationRepository.logout()
        })
        
        let _loadExercises = PublishSubject<Int>()
        loadExercises = _loadExercises.asObserver()
        
        let _selectExercise = PublishSubject<Exercise>()
        selectExercise = _selectExercise.asObserver()
        didSelectExercise = _selectExercise.asObservable().map { (exercise) -> Exercise in
            return exercise
        }
        
        _loadExercises.asObservable().flatMap { n ->
            Observable<ResultCollection<Exercise>>  in
            self.page.value = n
            return ContentRepository.sharedInstance.getExercisesWithImages(pageNumber: n)
        }.map({ [weak self] resultCollection -> [Exercise] in
            switch resultCollection {
            case .success(let exercises):
                guard let strongSelf = self else {
                    return []
                }
                
                (strongSelf.page.value == 1) ? strongSelf._exercisesVariable.value = exercises : strongSelf._exercisesVariable.value.append(contentsOf: exercises)
                return strongSelf._exercisesVariable.value
            case .error(let error):
                self?._error.asObserver().onNext(error.errorType.rawValue)
                return []
            }
        }).bind(to: _exercisesVariable).disposed(by: disposeBag)
    }
    
}
