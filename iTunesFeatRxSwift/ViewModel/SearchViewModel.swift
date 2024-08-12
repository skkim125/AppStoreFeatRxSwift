//
//  SearchViewModel.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import Foundation
import RxSwift

final class SearchViewModel: BaseViewModel {
    private let iTunesAPI = ITunesAPI.shared
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchText: PublishSubject<String>
        let searchButtonClicked: PublishSubject<Void>
        let indexPath: PublishSubject<IndexPath>
        let model: PublishSubject<Application>
    }
    
    struct Output {
        let applications: PublishSubject<[Application]>
        let lastText: PublishSubject<String>
        let showSearchTextIsEmptyAlert: PublishSubject<Void>
        let showErrorAlert: PublishSubject<Void>
        let appDetail: PublishSubject<(IndexPath, Application)>
    }
    
    func transform(input: Input) -> Output {
        let lastText = PublishSubject<String>()
        let applications = PublishSubject<[Application]>()
        let showSearchTextIsEmptyAlert = PublishSubject<Void>()
        let showErrorAlert = PublishSubject<Void>()
        let appDetail = PublishSubject<(IndexPath, Application)>()
        
        input.searchButtonClicked
            .withLatestFrom(input.searchText) { _, text in
                return (text, !text.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .bind(with: self) { owner, value in
                if value.1 {
                    lastText.onNext(value.0)
                } else {
                    showSearchTextIsEmptyAlert.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        lastText
            .flatMap { 
                self.iTunesAPI.calliTunes(router: .entity(term: $0))
                    .catch { error in
                        showErrorAlert.onNext(())
                        return Single<[Application]>.never()
                    }
            }
            .bind(with: self) { owner, value in
                applications.onNext(value)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(input.indexPath, input.model)
            .bind(with: self) { owner, value in
                appDetail.onNext(value)
            }
            .disposed(by: disposeBag)
        
        return Output(applications: applications, lastText: lastText, showSearchTextIsEmptyAlert: showSearchTextIsEmptyAlert, showErrorAlert: showErrorAlert, appDetail: appDetail)
    }

}
