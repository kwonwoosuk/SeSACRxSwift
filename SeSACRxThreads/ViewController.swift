//
//  ViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


enum sukError: Error {
    case incorrect
}

class ViewController: UIViewController {
    
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    //publish와 비교해서 한번 사용해보겠음
    let textFieldText = BehaviorRelay(value: "고래밥\(Int.random(in: 1...100))") // 무조건 실행된다 전달해줄 수 있는 초기값이 무조건 있기때문에 / 실행이 처음부터 안되게 하고 싶으면 publishSubject 사용하면 어떨까
    // viewdidload 시점에 구독되는것을 방지
//    let textFieldText = PublishSubject<String>()
    
    let publishSubject = PublishSubject<Int>()
    let behaviorSubject = BehaviorSubject(value: 0)
    
    let quiz = Int.random(in: 1...10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        //        bindButton()
        bindTextField()
        
        bindCustomObservarble()
        print(quiz, "quiz")
        
        randomNumber()
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    func randomNumber() -> Observable<Int> {
        return Observable<Int>.create { value in
            value.onNext(Int.random(in: 1...10))
            return Disposables.create()
        }
    }
    
    func randomQuiz(number: Int) -> Observable<Bool> {
        return Observable<Bool>.create { value in
            
            if number == self.quiz {
                value.onNext(true)
                value.onCompleted() //  해주어야 커스텀 옵저버블이 해제될 수 있게 된다 !! Leak발생시키고 싶지 않으면 신경쓰자요
                
            } else {
                value.onNext(false) // -> 버튼의 옵저버블은 하나임 -> 버튼을 클릭하면 play()실행되어 randomQuiz 옵저버블이 생성되고 누를때마다 생성되어 해제되지 않음 !! leak!!!! 화면 전체가 완벽하게 deinit되기 전까지
                value.onCompleted() //⭐️⭐️⭐️⭐️⭐️ 꼭 작성 /
                
//                value.onError(sukError.incorrect)// 에러를 만나거나 컴플리트를 만나면 디스포즈됨 근데 버튼 클릭 됨 왜냐? 버튼 클릭시마다 play옵저버블이 생기기때문에 (옵저버블 안에 옵저버블이 들어 있을 수 있음)
                // 버튼 옵저버블 안에 있는 randomQuiz(number: value) 버튼 클릭시마다 생기는 또 다른 옵저버블이 dispose되는것임 버튼은 그래서 클릭 가능
            }
            return Disposables.create()
        }
    }
    
    func play(value: Int) {
        randomQuiz(number: value)
            .subscribe(with: self) { owner, value in
                print("next", value)
            } onError: { owner, error in
                print("onError")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
    }
    
    func bindCustomObservarble() {
        
        nextButton.rx.tap
            .map { Int.random(in: 1...10) }
            .bind(with: self) { owner, value in
                print("value", value)
                owner.play(value: value)
            }
            .disposed(by: disposeBag)
    }
    
    func bindTextField() {
        textFieldText
            .subscribe(with: self) { owner, value in
//                owner.nicknameTextField.text = value
                owner.nicknameTextField.rx.text.onNext(value)
                print("11111")
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(with: self) { owner, value in
                
                print("behavior에 글자 가져오기") // behaviorSubject안에 친구를 가져오고 싶은것
                print(owner.textFieldText.value) // 사실 내부적으로 try 있다
//                let result = try! owner.textFieldText.value()
//                print(result)
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
    //    func bindTextField() {
    //        //UI 처리에 특화된 Observable이 Trait
    //        // RxCoCoa의 Trait은 ControlProperty, controlEvent, Driver
    //        nicknameTextField.rx.text.orEmpty
    //            .subscribe(with: self) { owner, _ in
    //                print(#function, "실시간으로 텍스트 필드 달라짐 ")
    //            } onError: { owner, error in
    //                print(#function, "onError")
    //            } onCompleted: { owner in
    //                print(#function, "onCompleted")
    //            } onDisposed: { owner in
    //                print(#function, "onDisposed")
    //            }
    //            .disposed(by: disposeBag)
    //
    //        behaviorSubject
    //            .subscribe(with: self) { owner, _ in
    //                print(#function, "클릭")
    //            } onError: { owner, error in
    //                print(#function, "onError")
    //            } onCompleted: { owner in
    //                print(#function, "onCompleted")
    //            } onDisposed: { owner in
    //                print(#function, "onDisposed")
    //            }
    //        .disposed(by: disposeBag)
    //
    //        nextButton.rx.tap
    //            .bind(with: self) { owner, _ in
    //                owner.nicknameTextField.text = "5"
    //            }
    //            .disposed(by: disposeBag)
    //    }
    
    //    func bindButton() {
    //        // MARK: - subscribe: next complete error 다 처리 할 수있는 친구 무조건 메인이 아니라 앞선 스트림에 영향을 받게 된다
    //        nextButton.rx.tap
    //                .subscribe(with: self) { owner, _ in
    //                    print(#function, "클릭")
    //                } onError: { owner, error in
    //                    print(#function, "onError")
    //                } onCompleted: { owner in
    //                    print(#function, "onCompleted")
    //                } onDisposed: { owner in
    //                    print(#function, "onDisposed")
    //                }
    //            .disposed(by: disposeBag)
    //
    //        // MARK: - bind: 스트림에 따라 어떤 스레드에서 실행될지 정해진다
    //        // 버튼 > 서버통신(비동기) > UI업데이트(Main)
    //        nextButton.rx.tap
    //            .map {
    //                print("1", Thread.isMainThread) // map이 어떤 스레드로 동작하고 있는지 체크
    //            }
    //            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
    //            .map {
    //                print("2", Thread.isMainThread)
    //            }
    //            .observe(on: MainScheduler.instance)
    //            .bind(with: self) { owner, _ in
    //                print("3", Thread.isMainThread)
    //                print(#function , "클릭")
    //                // 메인
    //            }
    //            .disposed(by: disposeBag)
    //
    //
    //        // MARK: - Drive: 메인스레드 실행을 보장 + share를 내포하고 있어 굳이 작성해서 사용할 필요없다 ui적인것을 핸들링 할때, main스트림을 보장받아야할때 사용
    //        nextButton.rx.tap // : SharedSequence<DriverSharingStrategy, Void> 타입
    //            .asDriver() // 다른 타입으로 살짝 감싸 주어야 한디
    //            .drive(with: self) { owner, _ in
    //                print("drive")
    //            }
    //            .disposed(by: disposeBag)
    //    }
    
    func bindButton() { //  스트림이 공유된다는것에 대한 의미를 보려함
        let button = nextButton.rx.tap
            .map {
                print("버튼클릭")
            }
            .debug("1")
            .debug("2")
            .debug("3")
            .map {
                "안녕하세요 \(Int.random(in: 1...100))"
            }
        //            .share() -> 드라이브 안에 이미 정의되어있음
        //            .asDriver(onErrorJustReturn: "") // 드라이브는 에러를 절대 받지 않기 때문에 에러처리를 하는곳이다 // 나 무조건 문자열 리턴해야하는데 안주면 어떡해 빈문자열이라도 내보낼게
        //드라이브 사용하는 순간 bind , subscribe사용할 수 없음, 무조건 드라이브로 받아야함
        button
        //            .drive(navigationItem.rx.title)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        
        button
        //            .drive(nextButton.rx.title())
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        button
        //            .drive(nicknameTextField.rx.text)
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    
    func configureLayout() {
        view.backgroundColor = .white
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

