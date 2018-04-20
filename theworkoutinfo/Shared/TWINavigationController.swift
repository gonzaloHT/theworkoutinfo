//
//  TWINavigationController.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/19/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import UIKit

class TWINavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
    }
   
    private func setStyle() {
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white , NSAttributedStringKey.font: UIFont.init(name: "Copperplate-Bold", size: 30) ??  UIFont.boldSystemFont(ofSize: 30)]
        navigationBar.backgroundColor = UIColor.greenAppColor()
        navigationBar.isTranslucent = false;
        navigationBar.barTintColor = UIColor.greenAppColor()
        view.backgroundColor = UIColor.greenAppColor()
        navigationBar.tintColor = UIColor.white
    }
}
