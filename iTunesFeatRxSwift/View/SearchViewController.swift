//
//  SearchViewController.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    private lazy var searchviewcontroller = UISearchController(searchResultsController: nil)
    private lazy var searchResultCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.searchResultCollectionViewLayout())
        cv.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        
        return cv
    }()
    
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        bind()
    }
    
    private func configuration() {
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureNavigationBar() {
        navigationLargeTitleModeOn()
        configureSearchController()
        configureNavigationBarDefaultAppearance()
        navigationItem.rx.title.onNext("검색")
        searchviewcontroller.searchBar.rx.placeholder.onNext("게임, 앱, 스토리 등")
    }
    
    private func configureHierarchy() {
        view.addSubview(searchResultCollectionView)
    }
    private func configureLayout() {
        searchResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func configureView() {
        view.backgroundColor = .systemBackground
        
    }
    
    private func bind() {
        let searchText = PublishSubject<String>()
        let searchButtonClicked = PublishSubject<Void>()
        let indexPath = PublishSubject<IndexPath>()
        let model = PublishSubject<Application>()
        
        let input = SearchViewModel.Input(searchText: searchText, searchButtonClicked: searchButtonClicked, indexPath: indexPath, model: model)
        let output = viewModel.transform(input: input)
        
        searchviewcontroller.searchBar.rx.searchButtonClicked
            .bind(to: searchButtonClicked)
            .disposed(by: disposeBag)
        
        searchviewcontroller.searchBar.rx.text.orEmpty
            .bind(to: searchText)
            .disposed(by: disposeBag)
        
        searchResultCollectionView.rx.itemSelected
            .bind(to: indexPath)
            .disposed(by: disposeBag)
        
        searchResultCollectionView.rx.modelSelected(Application.self)
            .bind(to: model)
            .disposed(by: disposeBag)
        
        output.applications
            .bind(to: searchResultCollectionView.rx.items(cellIdentifier: SearchCollectionViewCell.id, cellType: SearchCollectionViewCell.self)) { item, value, cell in
                cell.configureCell(app: value)
            }
            .disposed(by: disposeBag)
        
        output.applications
            .map({ $0.isEmpty })
            .bind(with: self) { owner, isEmpty in
                owner.configureNavigationBarSearchAppearance()
                owner.searchResultCollectionView.rx.isHidden.onNext(isEmpty)
                if !isEmpty {
                    owner.searchResultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                } else {
                    owner.showAlert(title: "검색 결과가 없습니다.", message: nil)
                }
            }
            .disposed(by: disposeBag)
        
        output.showSearchTextIsEmptyAlert
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "한글자 이상 입력해주세요", message: nil)
                owner.searchviewcontroller.searchBar.rx.text.onNext(nil)
            }
            .disposed(by: disposeBag)
        
        output.appDetail
            .bind(with: self) { owner, value in
                let vc = ApplicationDetailViewController()
                vc.viewModel.outputApplication.onNext(value.1)
                vc.configureView(app: value.1)
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.showErrorAlert
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "에러가 발생하였습니다.", message: nil)
            }
            .disposed(by: disposeBag)
        
        searchviewcontroller.searchBar.rx.cancelButtonClicked
            .withLatestFrom(output.applications)
            .bind(with: self) { owner, value in
                if !value.isEmpty {
                    owner.searchResultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                owner.configureNavigationBar()
                owner.searchResultCollectionView.rx.isHidden.onNext(true)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        configureNavigationBarDefaultAppearance()
    }
    
    private func configureSearchController() {
        navigationItem.rx.searchController.onNext(searchviewcontroller)
        searchviewcontroller.searchBar.rx.searchBarStyle.onNext(.minimal)
        searchviewcontroller.searchBar.searchTextField.rx.returnKeyType.onNext(.search)
        searchviewcontroller.rx.hidesNavigationBarDuringPresentation.onNext(true)
    }
}
