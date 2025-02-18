//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    let emailText = Observable.just("a@a.com") // 글자
    
    let backgroundColor = Observable.just(UIColor.lightGray)
    
    let signUpTitle = Observable.just("회원이 아직 아니십니까?")
    let signUpTitleColor = Observable.just(UIColor.red)
    
    func bindBackgroundColor() {
        // 1단계
//        backgroundColor
////            .withUnretained(self) // 순환참조의 목적 -> 모든 코드에 들어가는데 다 쳐야될까? subscribe할때 with매개변수있는거 봤을텐데 ! -> 밑줄
//            .subscribe(with: self) { owner,
//                value in // owner보통 많이 씀
//                self.view.backgroundColor = value
//            } onError: { owner, error in
//                print(#function, error)
//            } onCompleted: { owner in
//                print(#function,"onCompleted")
//            } onDisposed: { owner in
//                print(#function, "onDisposed")
//            }
//            .disposed(by: disposeBag)
//        
//        // 호출되지 않는 이벤트 생략 2단계
//        backgroundColor
//            .subscribe(with: self) { owner,
//                value in // owner보통 많이 씀
//                self.view.backgroundColor = value
//            }
//            .disposed(by: disposeBag)
//        // 이벤트를 받지 못하는 bind로 next만 동작되면 되는 기능이라면  bind로 구현 -> UI에 관련된것을 대부분 bind로 구현
//        backgroundColor
//            .bind(with: self) { owner, value in
//                owner.view.backgroundColor = value
//            }
//            .disposed(by: disposeBag)
        signUpButton
            .rx
            .tap
            .bind { _ in
                self.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
     
        
        
        backgroundColor
            .bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        
        
//            .subscribe { value in
//                self.view.backgroundColor = value
//            } onError: { error in
//                print(#function, error)
//            } onCompleted: {
//                print(#function,"onCompleted")
//            } onDisposed: { //  안쓰더라도 // .disposed(by: disposeBag) 확인가능 대신 print로 시점확인이 안되는것이지
//                print(#function, "onDisposed")
//            }
//            .disposed(by: disposeBag)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        bindBackgroundColor()
        configureLayout()
        configure()
        
        
        
        
//        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        //async, stream 늘상 사용하던것들을 새로운 방법을 제시 해줄게 ~ 터치업 인사이드를 rx로 전환한것 뿐
        signUpButton
            .rx //  라인마다 타입이 다르다
            .tap // 그래서 스트림( 시퀀스가 흘러가서)
            .bind { _ in //  데이터가 흐름에 따라 변화한것이구나 ~! -> observable streams과 함께 asynchronous programming를 지원하는게 알엑스구나 하고 이해 하면 좋을 것같다 
                self.navigationController?.pushViewController(SignUpViewController(), animated: true) //🔵
            }
            .disposed(by: disposeBag)
        
//        signUpButton
//            .rx
//            .tap //  여기까지가 사실상 Observable
//            .subscribe { _ in
//                self.navigationController?.pushViewController(SignUpViewController(), animated: true)
//                print("button OnNext")
//            } onError: { error in
//                print("button OnError")
//            } onCompleted: {
//                print("button onCompleted")
//            } onDisposed: {
//                print("button OonDisposed")
//            }
//            .disposed(by: disposeBag)
        
        
        emailText
            .subscribe { value in
                self.emailTextField.text = value
                print("emailText OnNext")
            } onError: { error in
                print("emailText OnError")
            } onCompleted: {
                print("emailText onCompleted")
            } onDisposed: {
                print("emailText OonDisposed")
            }
            .disposed(by: disposeBag)
        
    }
    
    
    @objc func signUpButtonClicked() {
//        navigationController?.pushViewController(SignUpViewController(), animated: true)🔵
    }
    
    
    func configure() {
//        signUpButton.setTitle("회원이 아니십니까?", for: .normal)

        signUpTitle
            .bind(to: signUpButton.rx.title())
            .disposed(by: disposeBag)
//        signUpButton.setTitleColor(Color.black, for: .normal)
        signUpTitleColor
            .bind(with: self, onNext: { owner, color in
                owner.signUpButton.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag )
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
