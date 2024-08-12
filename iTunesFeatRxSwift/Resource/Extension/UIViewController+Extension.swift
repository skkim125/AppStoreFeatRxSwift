//
//  UIViewController+Extension.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import UIKit
import RxSwift

extension UIViewController {
    func showAlert(title: String?, message: String?, completionHandelr: (()->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let open = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandelr?()
        }
        alert.addAction(open)
        
        present(alert, animated: true)
    }
    
    func navigationLargeTitleModeOn() {
        navigationController?.navigationBar.rx.prefersLargeTitles.onNext(true)
        navigationItem.rx.largeTitleDisplayMode.onNext(.always)
    }
    
    func navigationLargeTitleModeOff() {
        navigationController?.navigationBar.rx.prefersLargeTitles.onNext(false)
        navigationItem.rx.largeTitleDisplayMode.onNext(.never)
    }
    
    func configureNavigationBarDefaultAppearance() {
        let navigationBar = navigationController?.navigationBar
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemBackground
        navigationBarAppearance.shadowColor = .clear
        navigationBar?.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func configureNavigationBarSearchAppearance() {
        let navigationBar = navigationController?.navigationBar
        let navigationBarAppearance = UINavigationBarAppearance()
        
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBar?.scrollEdgeAppearance = navigationBarAppearance
        navigationBar?.compactScrollEdgeAppearance = navigationBarAppearance
    }
}
