//
//  HomeViewController.swift
//  theworkoutinfo
//
//  Created by Gonzalo Barrios on 4/4/18.
//  Copyright © 2018 Gonzalo Barrios. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ESPullToRefresh

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var filterView: UIView!
    @IBOutlet weak var tableViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryTextField: UITextField!
    
    //MARK: - Vars
    
    var disposeBag = DisposeBag()
    var viewModel: HomeViewModel
    var rc = UIRefreshControl()
    var categoryPickerView = UIPickerView()
    var filterButton = UIBarButtonItem()
    var logoutButton = UIBarButtonItem()
    
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
        
        logoutButton = UIBarButtonItem(image: UIImage(named: "Logout-Icon"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = logoutButton;
        
        filterButton = UIBarButtonItem(image: UIImage(named: "FilterIcon"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = filterButton;
        
        tableView.register(UINib(nibName: FeedTableViewCell.cellNibName, bundle: nil), forCellReuseIdentifier: FeedTableViewCell.cellReuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.lightGray
        tableView.tableFooterView = UIView()
        tableView.addSubview(rc)
        self.tableView.es.addInfiniteScrolling {
            [unowned self] in
            self.viewModel.loadMoreExercises.onNext(())
        }
        
        categoryTextField.inputView = categoryPickerView
        categoryTextField.text = "Select a category"
        filterView.backgroundColor = UIColor.greenAppColor()
    }
    
    func setupBindings() {
        
        viewModel.isLoading.bind(to: self.rx.isLoading)
            .disposed(by: disposeBag)
        
        viewModel.loadCategories.onNext(())
        
        viewModel.exercises.asObservable().subscribe(onNext: { _ in
            self.rc.endRefreshing()
            self.tableView.es.stopLoadingMore()
        }).disposed(by: disposeBag)
        
        rc.rx.controlEvent(.valueChanged).subscribe({ _ in
            self.viewModel.reloadExercises.onNext(())
        }).disposed(by: disposeBag)
        
        viewModel.categories.asObservable().bind(to: categoryPickerView.rx.itemTitles) { _, item in
            return item.name
            }.disposed(by: disposeBag)
        
        categoryPickerView.rx.modelSelected(ExerciseCategory.self)
            .subscribe(onNext: {
                categoriesSelected in
                
                guard let category = categoriesSelected.first else {
                    return
                }
                
                self.viewModel.selectCategory.onNext((category))
                self.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        viewModel.didSelectCategory.subscribe(onNext: { (category) in
            (category.id == -1) ? (self.categoryTextField.text = "Select a category") : (self.categoryTextField.text = category.name)
        }).disposed(by: disposeBag)
        
        viewModel.exercises.bind(to: tableView.rx.items(cellIdentifier: FeedTableViewCell.cellReuseIdentifier, cellType: FeedTableViewCell.self)) { (row, exercise, cell) in
            cell.setup(withExercise: exercise)
            cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Exercise.self).do(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).bind(to: viewModel.selectExercise)
            .disposed(by: disposeBag)
        
        viewModel.error.asObservable().subscribe(onNext: { error in
            self.showAlert(withTitle: "Error", message: error, buttonTitle: "OK")
        }).disposed(by: disposeBag)
        
        logoutButton.rx.tap.bind(to: viewModel.tryLogout)
            .disposed(by: disposeBag)
        
        filterButton.rx.tap.bind(to: viewModel.tryShowFilterView)
            .disposed(by: disposeBag)
        
        viewModel.shouldShowFilterView.subscribe(onNext: { _ in
            self.showFilterByView()
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Private Funcs
    
    private func showFilterByView() {
        if tableViewTopSpaceConstraint.constant == 0 {
            tableViewTopSpaceConstraint.constant = 70
        } else {
            tableViewTopSpaceConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
