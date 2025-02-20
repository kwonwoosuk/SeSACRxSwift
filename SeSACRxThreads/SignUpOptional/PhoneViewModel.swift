//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/19/25.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel {
    
    init() {
        print("PhoneViewModel Init")
    }
    
    struct Input {
        // 버튼을 클릭하는 행위 Rx.tap의 타입과 맞춰준것을 입력
        let tap: ControlEvent<Void>
        let text: ControlProperty<String>
        
        // 텍스트 필드 글자
    }
    
    struct Output {
        // 버튼클릭
        let tap: ControlEvent<Void>
        // 버튼 텍스트           뷰컨에서 버튼 타이틀에 뭐가 들어간는지 몰라도 되니까 ~
        let text: Observable<String>
        //let a = Observable.just("연락처는 8자 이상")
        
        // 버튼 유효성
        let validation: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
             
        let buttonText = Observable.just("연락처는 8자 이상")
        
       let validation =  input.text
            .map { $0.count >= 8 }
        
        return Output( // == nextButton.rx.tap
            tap: input.tap, // input을 통해 들어온 탭을 그대로 내 뱉겠다 == void로 다시 돌려보냈던거랑 같은 행동을 이렇게 한다
            text: buttonText,
            validation: validation
        )
    }
    
    
    
    
    
    
    
    
    
    
}
