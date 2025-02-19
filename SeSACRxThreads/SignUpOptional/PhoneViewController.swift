//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa // 내안에 uikit있다... 
import SnapKit

class PhoneViewController: UIViewController {
    
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let viewModel = PhoneViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        //nextButton.rx.tap
        //phoneTextField.rx.text.orEmpty
        let input = PhoneViewModel.Input(
            tap: nextButton.rx.tap,
            text: phoneTextField.rx.text.orEmpty
        )// 이 인스턴스를 뷰모델로 넘겨주어야 된다 이제
        
        let output = viewModel.transform(input: input)
        

        output.tap
            .bind(with: self) { owner, _ in
                print("버튼이 클릭되었습니다")
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        
        output.text
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        
//        phoneTextField.rx.text.orEmpty // == Observable.just(false) 와 최종적인 타입이 동일하다
//        // 이것도 비지니스 모델로 보는 사람도 있고 아닌사람도 있고
//            .map { $0.count >= 8 }
        
        output.validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        
    }
    
    
    
    
    //    @objc func nextButtonClicked() {
    //        navigationController?.pushViewController(NicknameViewController(), animated: true)
    //    }
    
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
