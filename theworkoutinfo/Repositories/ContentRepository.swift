//
//  ContentRepository.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/4/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import RxSwift

class ContentRepository {
    
    static let sharedInstance = ContentRepository()
    
    var exerciseList = Variable<[Exercise?]?>(nil)
    
    var disposeBag = DisposeBag()
    
    func getExercisesByCategoryId(categoryId: Int?, pageNumber: Int) -> Observable<ResultCollection<Exercise>> {
        return RequestHelper.sharedInstance.performRequestCollection(service: .exercisesByCategory(categoryId: categoryId, pageNumber: pageNumber)).flatMap({ (result: ResultCollection<Exercise>) -> Observable<ResultCollection<Exercise>> in
            if case .success(let exercises) = result {
                return Observable.from(exercises).flatMap({ (exercise) -> Observable<Exercise> in
                    return RequestHelper.sharedInstance.performRequestCollection(service: .exerciseImage(exerciseId: exercise.id))
                        .map({ (imagesResult: ResultCollection<ExerciseImage>) -> Exercise in
                            if case .success(let images) = imagesResult {
                                exercise.imageURL = images.first?.image
                                return exercise
                            } else {
                                return exercise
                            }
                        })
                }).toArray().map({
                    ResultCollection.success($0)
                })
            }
            return Observable.from(optional: result)
        })
    }
    
    func getExercisesCategories() -> Observable<ResultCollection<ExerciseCategory>> {
        return RequestHelper.sharedInstance.performRequestCollection(service: .exerciseCategories).flatMap({ (result: ResultCollection<ExerciseCategory>) -> Observable<ResultCollection<ExerciseCategory>> in
            return Observable.just(result)
        })
    }
}
