//
//  LoginViewController.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 3/16/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var disposeBag = DisposeBag()
    var viewModel: LoginViewModel
    
    //MARK: - Lifecycle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }
    
    //MARK: - Setup
    
    func setupBindings() {
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.tryLogin)
            .disposed(by: disposeBag)
        
        viewModel.errorMessage.do(onNext: { errorMessage in
            self.showAlert(withTitle: "Error", message: errorMessage, buttonTitle: "OK")
        }).subscribe()
            .disposed(by: disposeBag)
    }

}
