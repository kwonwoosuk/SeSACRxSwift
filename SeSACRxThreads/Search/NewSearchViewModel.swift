//
//  NewSearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/24/25.
//

import Foundation
import RxSwift
import RxCocoa
// 0224
final class NewSearchViewModel {
    
    
    struct Input {
        let searchTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let list: Observable<[DailyBoxOfficeList]> //  일단은 스트링 배열로 내보내 줄게용
    }
    
    let disposeBag = DisposeBag()
    
    // map withLatestForm, flatMap, flatMapLatest ... 오퍼레이터 쓸때마다 체크해보고 테스트해보고 결정, 모두 외울 순 없당...
    func transform(input: Input) -> Output {
        
        let list = PublishSubject<[DailyBoxOfficeList]>()
        
        input.searchTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map{
                guard let text = Int($0) else {
                    return 20250223 //최소한 어제날짜로 보여주려고 작성함
                }
                return text // Int이기때문에
            }
            .map { return "\($0)" } // String으로 변환을 해주고 싶었던것
            .flatMap {
                NetworkManager.shared.callBoxOfficeWithSingle(date: $0).debug("Movie") // -> Movie를 리턴하는 커스텀옵져버블 이다 ! func callBoxOffice(date: String) -> Observable<Movie>
            }//WithSingle
            .debug("Tap")
            .subscribe(with: self) { owner, value in //value: Movie⭐️  서버 통신에서 flatMap을 사용하는 이유다 !
                //map을 사용했기때문에 vlaue에서 한번 더가져와야함 그래서 flatmap을 사용한다
                list.onNext(value.boxOfficeResult.dailyBoxOfficeList)
            } onError: { owner, error in
                print("onError")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        return Output(list: list)
    }
}


//        input.searchTap
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(input.searchText)
//            .distinctUntilChanged()
//            .map{
//                guard let text = Int($0) else {
//                    return 20250223 //최소한 어제날짜로 보여주려고 작성함
//                }
//                return text // Int이기때문에
//            }
//            .map { return "\($0)" } // String으로 변환을 해주고 싶었던것
//            .map {
//                NetworkManager.shared.callBoxOffice(date: $0) // -> Movie를 리턴하는 옵져버블 이다 ! func callBoxOffice(date: String) -> Observable<Movie>
//            }
//            .subscribe(with: self) { owner, value in //value: Observable<Movie>⭐️
//              //map을 사용했기때문에 vlaue에서 한번 더가져와야함 그래서 flatmap을 사용한다
//              print("next", value)
//            } onError: { owner, error in
//                print("onError")
//            } onCompleted: { owner in
//                print("onCompleted")
//            } onDisposed: { owner in
//                print("onDisposed")
//            }
//            .disposed(by: disposeBag)
