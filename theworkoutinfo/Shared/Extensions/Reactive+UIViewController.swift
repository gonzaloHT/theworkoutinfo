//
//  Reactive+UIViewController.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 5/7/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    
    public var isLoading: Binder<Loader> {
        return Binder(self.base) { (viewController , animate) in
            if animate.wantAnimate {
                viewController.showLoader(withText: animate.message)
            } else {
                viewController.dismissLoader()
            }
        }
    }
    
}
