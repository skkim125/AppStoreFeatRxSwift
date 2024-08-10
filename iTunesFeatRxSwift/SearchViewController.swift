//
//  SearchViewController.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationLargeTitleModeOn()
        configureSearchController()
        navigationItem.rx.title.onNext("검색")
        searchController.searchBar.rx.placeholder.onNext("게임, 앱, 스토리 등")
    }
    
    private func navigationLargeTitleModeOn() {
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureSearchController() {
        navigationItem.rx.searchController.onNext(searchController)
        searchController.searchBar.rx.searchBarStyle.onNext(.minimal)
        searchController.searchBar.searchTextField.rx.returnKeyType.onNext(.search)
        searchController.rx.hidesNavigationBarDuringPresentation.onNext(true)
    }
}
