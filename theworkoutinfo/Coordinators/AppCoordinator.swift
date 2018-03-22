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
        let loginCoordinator = LoginCoordinator(window: window)
        
        let loginCoordinatorDidFinish = coordinate(to: loginCoordinator).observeOn(MainScheduler.instance)
        
        loginCoordinatorDidFinish.do(onNext: { [weak self] in
            self?.showHome()
        }).subscribe()
            .disposed(by: disposeBag)
        return Observable.never()
    }
    
    private func showHome() {
        //TODO: Home Screen
        print("presenting home")
    }
        
}
