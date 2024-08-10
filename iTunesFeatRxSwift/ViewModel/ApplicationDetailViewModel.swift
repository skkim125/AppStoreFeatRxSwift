//
//  ApplicationDetailViewModel.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import Foundation
import RxSwift

final class ApplicationDetailViewModel {
    var application: Application?
    let disposeBag = DisposeBag()
    
    let outputApplication = PublishSubject<Application>()
    
    init() {
        guard let application = application else { return }
        
        outputApplication.onNext(application)
    }
}
