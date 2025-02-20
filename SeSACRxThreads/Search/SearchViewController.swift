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
    
    lazy var items = BehaviorSubject(value: data)
    
    var data = [
        "첫 번째 Item",
        "두 번째 Item",
        "세 번째 Item","Asdfa" ,"asdfafs","asdfadsf","asdfadsf","asdfasdfasdf","asdfasfdasdf",
        "AAA",
        "C", "B", "AB", "ASC"
    ]
    
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
                cell.downloadButton.rx.tap
                    .bind(with: self) { owner, _ in
                        print("버튼클릭")
                        owner.navigationController?.pushViewController(DetailViewController(), animated: true)
                    }
                    .disposed(by: cell.disposeBag) // 내 셀이 있는 dispose를 관리하는 형태로 바꿔야해서 각셀 마다 각 디스포스가 있어야함  
            }
            .disposed(by: disposeBag)
        
        
        //서치바 + 엔터+ append
        searchBar.rx.searchButtonClicked // return키 탭했을때 기능이 들어가 있음
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(with: self) { owner, woosuk in
                print("search Tapped", owner.searchBar.text, woosuk)
                //                owner.data.append(woosuk)
                owner.data.insert(woosuk, at: 0)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        
        // 실시간 검색
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) //  서버 통신에 유용히 사용할 수 있다 !
            .distinctUntilChanged() // 동일한 글자라면 무시해라 !
            .bind(with: self) { owner, value in
                print(value)
                // 데이터가 100만개 혹은 실시간 서버통신을 하게 되면 / 한글특성상 여러번 검색을 하게 된다...
                let result = value == "" ?
                owner.data :
                owner.data.filter {
                    $0.contains(value)
                }
                
                owner.items.onNext(result)
                
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
