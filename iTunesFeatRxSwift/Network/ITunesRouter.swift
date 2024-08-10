//
//  ITunesRouter.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import Foundation
import Alamofire

enum ITunesRouter {
    case entity(term: String)
    
    var parameters: Parameters {
        switch self {
        case .entity(let term):
                [ 
                    "term": "\(term)",
                    "country": "KR",
                    "entity": "software"
                  ]
        }
    }
}
