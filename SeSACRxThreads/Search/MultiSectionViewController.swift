//
//  MultiSectionViewController.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/25/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

struct Mentor { // 섹션
    let name: String
    var items: [Item]
}

struct Ment {
    let word: String
    let count = Int.random(in: 1...1000)
}

extension Mentor: SectionModelType {
    typealias Item = Ment
    
    init(original: Mentor, items: [Item]) {
        self = original
        self.items = items
    }
}



final class MultiSectionViewController: UIViewController {
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
                                        //TableViewSectionedDataSource<SectionModelType>
        let dataSource = RxTableViewSectionedReloadDataSource<Mentor> { dataSource, tableView, IndexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: IndexPath)
            cell.textLabel?.text = "\(item.word) - \(item.count)번"
            return cell
        }
        
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].name
        }
        
        let mentor = [
            Mentor(name: "Jack", items: [Ment(word: "맛점하셨나요?"),Ment(word: "다시해볼까요?"),Ment(word: "가보겠습니다"),
                   Ment(word: "자 과제 나갑니다"), Ment(word: "저는 여러분이 고생했으면 좋겠어요")]),
                   
                   
            Mentor(name: "Den", items: [Ment(word: "정답은 없죠"), Ment(word: "그건 00님이 찾아보고 알려주세요")])
            
        ]
        
        Observable.just(mentor)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sectionCell")
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }


}
