//
//  SimpleTableViewController.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/26/25.
//

import UIKit
import SnapKit

//0226
final class SimpleTableViewController: UIViewController {

    private lazy var tableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
 
}


extension SimpleTableViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell")!
//        cell.textLabel?.text = "test"
        // ListCell⭐️, ViewConfiguration   == Presentation-> 구조체 기반이고 프로토콜 기반이고 하는것을 보여주고 싶었다
        var content = cell.defaultContentConfiguration() // => UIListContentConfiguration을 반환한다
        
        content.text = "그냥 텍스트"
        content.secondaryText = "두번째 텍스트"
        content.image = UIImage(systemName: "star")
        content.textProperties.color = .green
        content.textProperties.font = .boldSystemFont(ofSize: 20)
        content.imageProperties.tintColor = .systemPink
        content.imageProperties.cornerRadius = 10
        
        content.imageToTextPadding = 100
        
        
        cell.contentConfiguration = content // 타입으로써의 프로토콜로 사용 // 이거 왜 되는거라고여?
        return cell
    }
    
    
}
