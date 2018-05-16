//
//  UIViewController+Loader.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 5/4/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import SVProgressHUD

extension UIViewController {
    
    func showLoader(withText text: String?) {
        SVProgressHUD.show(withStatus: text)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }
    
}
