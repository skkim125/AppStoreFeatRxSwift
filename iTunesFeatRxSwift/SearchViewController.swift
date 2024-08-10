//
//  SearchViewController.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/10/24.
//

import UIKit

final class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "게임, 앱, 스토리 등"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

}
