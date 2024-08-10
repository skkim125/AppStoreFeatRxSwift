//
//  SearchViewModel.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import Foundation
import RxSwift

final class SearchViewModel {
    private let iTunesAPI = ITunesAPI.shared
    let disposeBag = DisposeBag()
    
    let inputSearchText = PublishSubject<String>()
    let inputSearchButtonTap = PublishSubject<Void>()
    let inputIndexPath = PublishSubject<IndexPath>()
    let inputModel = PublishSubject<Application>()
    
    let outputSearchText = PublishSubject<String>()
    let outputNavigationTitle = PublishSubject<String>()
    let outputApplications = PublishSubject<[Application]>()
    let outputShowAlert = PublishSubject<Void>()
    let outputScrollToTop = PublishSubject<Void>()
    let outputApplicationsIsEmpty = PublishSubject<Bool>()
    let outputMoveAppDetail = PublishSubject<(IndexPath, Application)>()
    
    init() {
        let text = inputSearchText
            .map({ "\($0)" })
        
        inputSearchButtonTap
            .withLatestFrom(text) { _, text in
                return ("\(text)", text.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .subscribe(with: self) { owner, text in
                if !text.1 {
                    owner.outputSearchText.onNext(text.0)
                    owner.outputNavigationTitle.onNext(text.0)
                } else {
                    owner.outputShowAlert.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        outputSearchText
            .flatMap { self.iTunesAPI.calliTunes(router: .entity(term: $0)) }
            .bind(with: self) { owner, value in
                owner.outputApplications.onNext(value)
                owner.outputScrollToTop.onNext(())
            }
            .disposed(by: disposeBag)
        
        outputApplications
            .map({ $0.isEmpty })
            .bind(with: self) { owner, isEmpty in
                owner.outputApplicationsIsEmpty.onNext(isEmpty)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(inputIndexPath, inputModel)
            .bind(with: self) { owner, value in
                owner.outputMoveAppDetail.onNext(value)
            }
            .disposed(by: disposeBag)
    }
}
