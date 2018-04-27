//
//  HomeCoordinator.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/4/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum HomeCoordinatorResult {
    case logout
}

class HomeCoordinator: BaseCoordinator<HomeCoordinatorResult> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<HomeCoordinatorResult> {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)
        let navigationController = TWINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let didLogout = viewModel.didLogout.map { _ -> HomeCoordinatorResult in
            AuthenticationRepository.logout()
            return HomeCoordinatorResult.logout
        }
        
        _ = viewModel.didSelectExercise.do(onNext: {(exercise) -> Void in
            
            let exerciseDetailViewModel = ExerciseDetailViewModel(exercise: exercise)
            let exerciseDetailViewController = ExerciseDetailViewController(viewModel: exerciseDetailViewModel)
            navigationController.pushViewController(exerciseDetailViewController, animated: true)
        }).subscribe()
        
        return didLogout
    }

}
