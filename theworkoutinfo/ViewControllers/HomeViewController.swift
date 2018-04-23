//
//  HomeViewController.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/4/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Vars
    
    var disposeBag = DisposeBag()
    var viewModel: HomeViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    //MARK: - Setup
    
    fileprivate func setupUI() {
        title = "The Workout Info"
        let leftButton = UIBarButtonItem(image: UIImage(named: "Logout-Icon"), style: .plain, target: self, action:#selector(logout))
        navigationItem.leftBarButtonItem = leftButton;
        tableView.register(UINib(nibName: FeedTableViewCell.cellNibName, bundle: nil), forCellReuseIdentifier: FeedTableViewCell.cellReuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.lightGray
        tableView.tableFooterView = UIView()
    }
    
    func setupBindings() {
        viewModel.loadExercises.onNext(())
        
        viewModel.exercises.bind(to: tableView.rx.items(cellIdentifier: FeedTableViewCell.cellReuseIdentifier, cellType: FeedTableViewCell.self)) { (row, exercise, cell) in
            cell.setup(withExercise: exercise)
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    @objc func logout() {
        viewModel.tryLogout.onNext(())
    }
    
}
