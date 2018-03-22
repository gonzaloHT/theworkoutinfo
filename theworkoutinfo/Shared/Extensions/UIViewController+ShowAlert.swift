//
//  UIViewController+ShowAlert.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/3/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
   
    func showAlert(withTitle title: String?, message: String, buttonTitle: String, showCancelButton: Bool = false, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let mainAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        if showCancelButton {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        alertController.addAction(mainAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
