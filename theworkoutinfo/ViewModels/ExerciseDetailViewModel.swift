//
//  ExerciseDetailViewModel.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 5/9/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import RxSwift

class ExerciseDetailViewModel {
    
    let disposedBag = DisposeBag()
    
    //MARK: - Outputs
    
    var exercise: Observable<Exercise> {
        return _exerciseVariable.asObservable()
    }
    
    //MARK: - Properties
    
    private let _exerciseVariable: Variable<Exercise>
    
    init(exercise: Exercise) {
        self._exerciseVariable = Variable<Exercise>(exercise)
    }
    
}
