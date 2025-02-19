//
//  BirthDayViewModel.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/19/25.
//

import Foundation
import RxSwift
import RxCocoa 

final class BirthDayViewModel {
    
    let disposeBag = DisposeBag()
    
    init() {
        print("BirthDayViewModel Init")
    }
    
    struct Input {
        let birthday: ControlProperty<Date>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let nextTap: ControlEvent<Void> //  그대로 다시 뱉어주는 것
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        
    }
    
    func transform(input: Input) -> Output {
        
        let year = BehaviorRelay(value: 2025)
        let month = BehaviorRelay(value: 2)
        let day = BehaviorRelay(value: 3)
        
        input.birthday //birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        return Output(
            nextTap: input.nextTap,
            year: year,
            month: month,
            day: day
        )
    }
    
}
