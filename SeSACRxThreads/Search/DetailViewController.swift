//
//  DetailViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DetailViewController: UIViewController {
    
    let nextButton = PointButton(title: "뻐튼")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        view.backgroundColor = .lightGray
        navigationItem.title = "Detail"
        // 내일 할것에 대한 이야기
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalTo(view)
        }
        
        
        
    }
    
    
    
    func bind() {
        
        let tap = nextButton.rx.tap
            .map { Int.random(in: 1...100) } // 같은결과를 다른곳에 보여주고 싶어서 여기까지 상수에 담는것
            .share() // 상수로 묶어 제역할을 할 수 있어진다 원하던대로 !!
        
        
        tap
            .bind(with: self) { owner, value in
                print("1번 - \(value)")
            }
            .disposed(by: disposeBag)
        
        tap
            .bind(with: self) { owner, value in
                print("2번 - \(value)")
            }
            .disposed(by: disposeBag)
        
        
        tap
            .bind(with: self) { owner, value in
                print("3번 - \(value)")
            }
            .disposed(by: disposeBag)
    }
}
