//
//  HomeworkViewModel.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/20/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeworkViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        // 엔터를 치는것행위를 인풋으로...
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let recentText: PublishSubject<String>
    }
    
    
    //let recent = BehaviorRelay(value: ["jack"])
    //let items = BehaviorSubject(value: ["test"])
    var recent = ["jack"]
    var items = ["test"]
    
    
    
    struct Output {
        let items: BehaviorSubject<[String]> // 테이블 뷰
        let recent: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorRelay(value: recent)
        
        let itemsList = BehaviorSubject(value: items)
        
        input.searchButtonTap
            .withLatestFrom(input.searchText)
            .map { "\($0)님"}
            .asDriver(onErrorJustReturn: "손님")
            .drive(with: self) { owner, value in
                owner.items.append(value)
                itemsList.onNext(owner.items)
            }
            .disposed(by: disposeBag)
        
        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recent.append(value)
                
                recentList.accept(owner.recent)
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            items: itemsList,
            recent: recentList.asDriver()
        )
        
        
    }
     
}
