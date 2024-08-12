//
//  BaseViewModel.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/12/24.
//

import Foundation
import RxSwift

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}
