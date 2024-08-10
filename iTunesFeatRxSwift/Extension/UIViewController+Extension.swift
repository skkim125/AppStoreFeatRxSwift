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
}
