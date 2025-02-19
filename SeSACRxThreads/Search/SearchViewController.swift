//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag() // 생성
    
    let items = Observable.just([
        "첫 번째 Item",
        "두 번째 Item",
        "세 번째 Item"
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
    
    
    
    func test() {
        
        let mentor = Observable.of("Hue", "Jack", "dd", "ddss")
        let age = Observable.of(10, 10, 10, 13)
        
        Observable.combineLatest(mentor, age)
            .bind(with: self) { owner, value in
                print(value.0, value.1)
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell ) in
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .lightGray
            }
            .disposed(by: disposeBag)
        
        
        //서치바 + 엔터+ append
        searchBar.rx.searchButtonClicked // return키 탭했을때 기능이 들어가 있음
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(with: self) { owner, woosuk in
                print("search Tapped", owner.searchBar.text, woosuk) // 시점확인
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
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}
