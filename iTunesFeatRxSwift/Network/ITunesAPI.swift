//
//  ITunesAPI.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import Foundation
import Alamofire
import RxSwift

final class ITunesAPI {
    static let shared = ITunesAPI()
    private init() { }
    
    func calliTunes(router: ITunesRouter) -> Observable<[Application]> {
        
        let result = Observable<[Application]>.create { observer in
            guard let url = URL(string: APIURL.ITunesURL) else {
                observer.onError(APIError.urlError)
                
                return Disposables.create()
            }
            
            AF.request(url, parameters: router.parameters).validate(statusCode: 200..<299).responseDecodable(of: ITunes.self) { response in
                switch response.result {
                case .success(let success):
                    observer.onNext(success.results)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
        
        return result
    }
}

enum APIError: Error {
    case urlError
    case responseError
}
