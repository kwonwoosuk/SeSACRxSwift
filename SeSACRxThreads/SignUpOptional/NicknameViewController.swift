//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
class NicknameViewController: UIViewController {
    
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let recommandList = ["뽀로로", "상어", "악어", "고래", "칙촉", "추천"]
    let nickname = Observable.just("닉네임")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        
        //        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
    }
    
    func bind() {
        nickname
            .subscribe(with: self) { owner, value in
                owner.nicknameTextField.text = value
            } onError: { owner, error in
                print("nickname OnError")
            } onCompleted: { owner in
                print("nickname onCompleted")
            } onDisposed: { owner in
                print("nickname onDisposed")
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(with: self) { owner, value in
                print("nextButton Next")
            } onError: { owner, error in
                print("nextButton onError")
            } onCompleted: { owner in
                print("nextButton onCompleted")
            } onDisposed: { owner in
                print("nextButton onDisposed")
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(BirthDayViewController(), animated: true)
    }
    
    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
