//
//  ApplicationDetailViewModel.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import Foundation
import RxSwift

final class ApplicationDetailViewModel: BaseViewModel {
    var application: Application?
    let disposeBag = DisposeBag()
    
    struct Input { }
    struct Output { }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    let outputApplication = PublishSubject<Application>()
    
    init() {
        guard let application = application else { return }
        
        outputApplication.onNext(application)
    }
}
