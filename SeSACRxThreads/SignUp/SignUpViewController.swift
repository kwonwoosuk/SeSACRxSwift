//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    let emailPlaceholder = Observable.just("이메일을 입력해주세요")
    
    var disposeBag = DisposeBag()
    
    func bind() {
        // 4자리 이상: 다음버튼 나타나고 중복 확인 버튼은 보이긴하나 클릭이 안됐다가 클릭이 되도록
        // 4자리 미만: 다음버튼 없고 중복 확인 버튼은 보이긴 하나 클릭이 안되는 상태
        
        
        let validation = emailTextField
            .rx
            .text // String?
            .orEmpty // String
            .map { $0.count >= 4 }
        
        //        validation
        //            .bind(to: validationButton.rx.isEnabled)
        //            .disposed(by: disposeBag)
        validation
            .subscribe(with: self) { owner, value in
                owner.validationButton.isEnabled = value
                print("Validation Next")
            }  onDisposed: { owner in
                print("Validation Disposed")
            }
        //            .dispose() //이메일에 아무리 열심히 만들어도 옵저버 구독취소를 했기떄문에 소용없다 // dispose는 바로 취소되다 보니 직접 불러 쓸일이 거의 없다
            .disposed(by: disposeBag)// 당장은 구독 취소 안하고 disposeBag이 살아있을때까지 구독
        
        
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
                print("중복확인 버튼 클릭")
                owner.disposeBag = DisposeBag() // 의도적으로 막은거고 VC가 Deinit되는 시점에 없에는게 가장 합리적이다
            }
            .disposed(by: disposeBag)
        
        
        
        
        emailPlaceholder
            .bind(to: emailTextField.rx.placeholder)
            .disposed(by: disposeBag)
    }
    
    func OperatorExample() {
        let itemA = [3,4,5,2,36,6,2]
        Observable.just(itemA) //내가 선택한 것을 just방식으로 보내줘라
            .subscribe(with: self) { owner, value in
                print("JUST \(value)")
            } onError: { owner, value in
                print("JUST \(value)")
            } onCompleted: { owner in
                print("Just")
            } onDisposed: { owner in
                print("Just")
            }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        bind()
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }
    
    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    
}
