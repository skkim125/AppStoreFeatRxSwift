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
    
    func calliTunes(router: ITunesRouter) -> Single<[Application]> {
        
        return Single<[Application]>.create { observer in
            
            guard let url = URL(string: APIURL.ITunesURL) else {
                observer(.failure(APIError.urlError))
                
                return Disposables.create()
            }
            
            let request = AF.request(url, parameters: router.parameters).validate(statusCode: 200..<299).responseDecodable(of: ITunes.self) { response in
                switch response.result {
                case .success(let success):
                    observer(.success(success.results))
                case .failure(let error):
                    guard let data = response.data else {
                        return observer(.failure(APIError.dataNilError))
                    }
                    
                    observer(.failure(APIError.responseError))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

enum APIError: Error {
    case urlError
    case dataNilError
    case decodingError
    case responseError
}
