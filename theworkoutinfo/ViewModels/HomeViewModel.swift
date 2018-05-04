//
//  HomeViewModel.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/4/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import RxSwift

public typealias Loader = (wantAnimate: Bool, message: String?)

class HomeViewModel {
    
    let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    let tryLogout: AnyObserver<Void>
    let selectExercise: AnyObserver<Exercise>
    let loadExercisesByCategory: AnyObserver<Void>
    let loadCategories: AnyObserver<Void>
    let tryShowFilterView: AnyObserver<Void>
    let selectCategory: AnyObserver<ExerciseCategory>
    let reloadExercises: AnyObserver<Void>
    let loadMoreExercises: AnyObserver<Void>
    
    //MARK: - Outputs
    
    let isLoading: Observable<Loader>
    let didLogout: Observable<Void>
    let didSelectExercise: Observable<Exercise>
    let shouldShowFilterView: Observable<Void>
    let didSelectCategory: Observable<ExerciseCategory>
    var exercises: Observable<[Exercise]> {
        return _exercisesVariable.asObservable()
    }
    
    var categories: Observable<[ExerciseCategory]> {
        return _categoriesBehavior.asObservable()
    }
    
    var error: Observable<String> {
        return _error.asObservable()
    }
    
    //MARK: - Properties
    
    private let _error = PublishSubject<String>()
    private let _exercisesVariable = Variable<[Exercise]>([])
    private let _categoriesBehavior = BehaviorSubject<[ExerciseCategory]>(value: [ExerciseCategory(id: -1, name: "All")])
    private let actualPage = Variable<Int>(1)
    private let actualCategory = Variable<ExerciseCategory>(ExerciseCategory(id: -1, name: "All"))
    
    init() {
        let showLoader: AnyObserver<Loader>
        
        let _reloadExercises = PublishSubject<Void>()
        reloadExercises = _reloadExercises.asObserver()
        
        let _loadMoreExercises = PublishSubject<Void>()
        loadMoreExercises = _loadMoreExercises.asObserver()
        
        let _tryLogout = PublishSubject<Void>()
        tryLogout = _tryLogout.asObserver()
        
        didLogout = _tryLogout.asObservable().map({
            AuthenticationRepository.logout()
        })
        
        let _loadExercisesByCategory = PublishSubject<Void>()
        loadExercisesByCategory = _loadExercisesByCategory.asObserver()
        
        let _loadCategories = PublishSubject<Void>()
        loadCategories = _loadCategories.asObserver()
        
        let _animate = PublishSubject<Loader>()
        showLoader = _animate.asObserver()
        isLoading = _animate.asObservable()
        
        let _showFilterView = PublishSubject<Void>()
        tryShowFilterView = _showFilterView.asObserver()
        shouldShowFilterView = _showFilterView.asObservable()
        
        let _selectCategory = PublishSubject<ExerciseCategory>()
        selectCategory = _selectCategory.asObserver()
        _selectCategory.asObservable()
            .bind(to: actualCategory)
            .disposed(by: disposeBag)
        didSelectCategory = actualCategory.asObservable()
        
        let _selectExercise = PublishSubject<Exercise>()
        selectExercise = _selectExercise.asObserver()
        didSelectExercise = _selectExercise.asObservable()
        
        _loadCategories.asObservable().flatMap { _ -> Observable<ResultCollection<ExerciseCategory>> in
            return ContentRepository.sharedInstance.getExercisesCategories()
            }.map({ [weak self] resultCollection -> [ExerciseCategory] in
                switch resultCollection {
                case .success(let categories):
                    var array = [ExerciseCategory(id: -1, name: "All")]
                    array.append(contentsOf: categories)
                    return array
                case .error(let error):
                    self?._error.asObserver().onNext(error.errorType.rawValue)
                    return []
                }
            }).bind(to: _categoriesBehavior.asObserver()).disposed(by: disposeBag)
        
        _loadExercisesByCategory.asObservable().flatMap { [weak self] _ -> Observable<ResultCollection<Exercise>> in
            guard let strongSelf = self else {
                return Observable.never()
            }
            
            if strongSelf.actualCategory.value.id == -1 {
                return ContentRepository.sharedInstance.getExercisesByCategoryId(categoryId: nil, pageNumber: (strongSelf.actualPage.value))
            }
            
            return ContentRepository.sharedInstance.getExercisesByCategoryId(categoryId: self?.actualCategory.value.id, pageNumber: strongSelf.actualPage.value)
            }.map({ [weak self] resultCollection -> [Exercise] in
                
                guard let strongSelf = self else {
                    return []
                }
                
                showLoader.onNext(Loader(false, nil))
                switch resultCollection {
                case .success(let exercises):
                    var ex = strongSelf._exercisesVariable.value
                    (strongSelf.actualPage.value == 1) ? ex = exercises : ex.append(contentsOf: exercises)
                    return ex
                case .error(let error):
                    strongSelf._error.asObserver().onNext(error.errorType.rawValue)
                    return strongSelf._exercisesVariable.value
                }
            }).bind(to: _exercisesVariable).disposed(by: disposeBag)
        
        didSelectCategory.do(onNext: { [weak self] (category) -> Void in
            self?.actualPage.value = 1
            (category.id == -1) ? showLoader.onNext(Loader(wantAnimate: true, message: "Loading all exercises")) : showLoader.onNext(Loader(wantAnimate: true, message: "Loading \(category.name) exercises"))
        }).map { _ in }.bind(to: loadExercisesByCategory).disposed(by: disposeBag)
        
        _reloadExercises.asObservable().do(onNext: { [weak self] in
            self?.actualPage.value = 1
        }).bind(to: loadExercisesByCategory).disposed(by: disposeBag)
        
        _loadMoreExercises.asObservable().do(onNext: { [weak self] in
            self?.actualPage.value += 1
        }).bind(to: loadExercisesByCategory).disposed(by: disposeBag)
    }
    
}
