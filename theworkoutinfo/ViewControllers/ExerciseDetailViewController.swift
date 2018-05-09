//
//  ExerciseDetailViewController.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/24/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ExerciseDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var exerciseDescription: UILabel!
    
    //MARK: - Vars
    
    let disposeBag = DisposeBag()
    let viewModel: ExerciseDetailViewModel
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }
    
    init(viewModel: ExerciseDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBindings() {
        viewModel.exercise.do(onNext: { (exercise) in
            self.exerciseDescription.text = exercise.description
            
            if let imageURL = exercise.imageURL {
                let url = URL(string: imageURL)
                self.exerciseImageView.kf.setImage(with: url)
            } else {
                self.exerciseImageView.image = UIImage(named: "AppMainIcon")
            }
        }).subscribe()
            .disposed(by: disposeBag)
    }
    
}
