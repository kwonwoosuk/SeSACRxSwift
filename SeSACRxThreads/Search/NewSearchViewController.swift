//
//  NewSearchViewController.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/24/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
// 2월 24일
class NewSearchViewController: UIViewController {

    private let tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    let viewModel = NewSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchController()
        configure()
        bind()
        
    }
    
    
    func bind() {
        
        let input = NewSearchViewModel.Input(
            searchTap: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty
        )
        
        let output = viewModel.transform(input: input)
        
        output.list
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) {
                (row, element, cell) in
                
                cell.appNameLabel.text = element.movieNm
            }
            .disposed(by: disposeBag)
        
        
        //TEST 1‼️
//        tableView.rx.itemSelected
//            .map { _ in //
//                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//            }
//            .subscribe(with: self) { owner, value in
//                print(value)
//                value.subscribe { number in
//                    print("number", number)
//                }
//                .disposed(by: owner.disposeBag)
//                
//            }
//            .disposed(by: disposeBag)
        
        //TEST2‼️
//        tableView.rx.itemSelected
//            .withLatestFrom(Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance))
//            .subscribe(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
        
        //TEST3‼️
//        tableView.rx.itemSelected
//            .flatMap { _ in
//                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//            }
//            .subscribe(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
        
        //TEST4‼️
        tableView.rx.itemSelected
            .flatMapLatest { _ in
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug("timer")
            }
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }
    
    private func configure() {
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    


}
