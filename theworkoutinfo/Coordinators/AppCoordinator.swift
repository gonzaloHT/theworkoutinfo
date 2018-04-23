//
//  AppCoordinator.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 3/16/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        if AuthenticationRepository.sharedInstance.isUserLoggedIn() {
             showHome()
        } else {
            showLogin()
        }
        
        return Observable.never()
    }
    
    private func showLogin() {
        let loginCoordinator = LoginCoordinator(window: window)
        let loginCoordinatorDidFinish = coordinate(to: loginCoordinator).observeOn(MainScheduler.instance)
        loginCoordinatorDidFinish.do(onNext: { [weak self] in
            return self?.showHome()
        }).subscribe()
            .disposed(by: disposeBag)
    }
    
    private func showHome() {
        let homeCoordinator = HomeCoordinator(window: window)
        let homeCoordinatorDidFinished = coordinate(to: homeCoordinator)
        homeCoordinatorDidFinished.do(onNext: { (_) -> Void in
            _ = self.start()
        }).subscribe()
            .disposed(by: disposeBag)
    }
        
}
