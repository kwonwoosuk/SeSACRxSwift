//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 권우석 on 2/24/25.
//

import Foundation
import RxSwift
import RxCocoa

//0224 API를 Movie를 반환하는 Observable로 !
enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}
struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Decodable {
    let movieNm, openDt: String
}


final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callBoxOffice(date: String) -> Observable<Movie> {
        
        return Observable<Movie>.create { value in
            let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=07918ad2a80648eb7bd0d5fb50437098&targetDt=\(date)"
            
            guard let url = URL(string: urlString)
            else {
                value.onError(APIError.invalidURL)
                return Disposables.create()  // {dispose가 되면 신호를 받고 싶거나 그때 무언가 하고싶을때 클로저 써주는것 (선택사항)}
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    value.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    value.onError(APIError.statusError)
                    return
                }
                
                if let data = data {
                    do  {
                        let result = try JSONDecoder().decode(Movie.self, from: data)
//                        value.onError(APIError.statusError)
                        value.onNext(result)
                        value.onCompleted()
                    } catch {
                        value.onError(APIError.unknownResponse)
                    }
                } else {
                    value.onError(APIError.unknownResponse)
                }
            }.resume()
            
            return Disposables.create {
                print("끝")
            }
            
        }
        
    }
    // ssSingle을 사용하는 이유
    func callBoxOfficeWithSingle(date: String) -> Single<Movie> {
        
        return Single<Movie>.create { value in
            let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=07918ad2a80648eb7bd0d5fb50437098&targetDt=\(date)"
            
            guard let url = URL(string: urlString)
            else {
                value(.failure(APIError.invalidURL))
                return Disposables.create()  // {dispose가 되면 신호를 받고 싶거나 그때 무언가 하고싶을때 클로저 써주는것 (선택사항)}
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    value(.failure(APIError.unknownResponse))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    value(.failure(APIError.statusError))
                    return
                }
                
                if let data = data {
                    do  {
                        let result = try JSONDecoder().decode(Movie.self, from: data)
                        value(.success(result))
                    } catch {
                        value(.failure(APIError.unknownResponse))
                    }
                } else {
                    value(.failure(APIError.unknownResponse))
                }
            }.resume()
            
            return Disposables.create {
                print("끝")
            }
            
        }
        
    }
}


//        let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=07918ad2a80648eb7bd0d5fb50437098&targetDt=\(date)"
//
//        guard let url = URL(string: urlString)
//        else {
//            completionHandler(
//                .failure(.invalidURL)
//            )
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completionHandler(
//                    .failure(.unknownResponse)
//                )
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse,
//                  (200...299).contains(response.statusCode) else {
//                completionHandler(
//                    .failure(.statusError)
//                )
//                return
//            }
//
//            if let data = data {
//                do  {
//                    let result = try
//                    JSONDecoder().decode(Movie.self, from: data)
//                    completionHandler(.success(result))
//                } catch {
//                    completionHandler(.failure(.unknownResponse))
//                 }
//                } else {
//                    completionHandler(.failure(.unknownResponse))
//                }
//        }.resume()
//
////            if let data = data,
////               let appData = try? // 문제생기면 nil이 나오기때문에 조심해서 써야한다
////                JSONDecoder().decode(Movie.self, from: data) {
////            }
//
//        }
//    }

