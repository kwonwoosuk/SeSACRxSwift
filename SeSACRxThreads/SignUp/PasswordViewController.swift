//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
class PasswordViewController: UIViewController {
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
//    let password = Observable.just("1234")
    let password = BehaviorSubject(value: "1234") //  1234를 전달도 할 수 있고 값을 바꿀 수도 있다/ 우리의 커스텀 옵져버블 처럼
    
    //SchedulerType == Main Global
    var disposeBag = DisposeBag()
    let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        //        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    deinit {
        // self 캡쳐, 순환참조, 메모리 누수로 인해서 deinit되지 않고 인스턴스가 계속 남아있음. Rx의 코드가 살아있는 상태
        // Deinit이 될때 구독이 정상적으로 해제된다.
        // deinit만 제대로 된다고 하면 Rx는 신경쓸게 없다 !
        // 왜 VC이 deinit되면 dispose 되는걸까요?
        print("Password Deinit")
    }
    
    
    func bind() {
        // dispose를 해제하는 시점을 수동으로 조절 할 수 있다
        timer
            .subscribe(with: self) { owner, value in
            print("Timer", value)
        } onError: { owner, error in
            print("Timer onError")
        } onCompleted: { owner in
            print("Timer onCompleted")
        } onDisposed: { owner in
            print("Timer onDisposed")
        }
        .disposed(by: disposeBag)

        
        
        password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("버튼클릭")
//
                
                
//                let random = [
//                    "1231", "asdfasf", "asdfasf"
//                ]
                // 1. 등호가 안되는이유 password가 옵져버블 이여서 이벤트를 전달만 하는거지 값을 받거나 무언가 직접 하는 건 아님
                // 2.
                owner.password.onNext("8888") // == owner.password = " 8888"  등호로 뭔갈 바꾸고 싶은건 next로 바뀠다
                
                
            }
            .disposed(by: disposeBag) // 모든 곳에 있어서 baseview로 뺼 수도있고 프로토콜로 사용하는 분도 있다
    }
    
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
