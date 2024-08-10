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
        searchviewcontroller.searchBar.rx.cancelButtonClicked
            .withLatestFrom(viewModel.outputApplications)
            .bind(with: self) { owner, value in
                if !value.isEmpty {
                    owner.searchResultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                owner.configureNavigationBar()
                owner.searchResultCollectionView.rx.isHidden.onNext(true)
            }
            .disposed(by: disposeBag)
        
        searchviewcontroller.searchBar.rx.searchButtonClicked
            .bind(to: viewModel.inputSearchButtonTap)
            .disposed(by: disposeBag)
        
        searchviewcontroller.searchBar.rx.text.orEmpty
            .bind(to: viewModel.inputSearchText)
            .disposed(by: disposeBag)
        
        viewModel.outputApplications
            .bind(to: searchResultCollectionView.rx.items(cellIdentifier: SearchCollectionViewCell.id, cellType: SearchCollectionViewCell.self)) { item, value, cell in
                cell.configureCell(app: value)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputScrollToTop
            .withLatestFrom(viewModel.outputApplicationsIsEmpty)
            .bind(with: self) { owner, isEmpty in
                owner.configureNavigationBarSearchAppearance()
                if !isEmpty {
                    owner.searchResultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        searchResultCollectionView.rx.itemSelected
            .bind(to: viewModel.inputIndexPath)
            .disposed(by: disposeBag)
        
        searchResultCollectionView.rx.modelSelected(Application.self)
            .bind(to: viewModel.inputModel)
            .disposed(by: disposeBag)
        
        viewModel.outputApplications
            .map({ $0.isEmpty })
            .withUnretained(viewModel.outputSearchText)
            .map({ ("\($0.0)", $0.1) })
            .bind(with: self) { owner, value in
                owner.searchResultCollectionView.rx.isHidden.onNext(value.1)
                if value.1 {
                    owner.showAlert(title: "\(value.0)에 대한 검색 결과가 없습니다.", message: nil)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.outputShowAlert
            .bind(with: self) { owner, _ in
                owner.showAlert(title: "한글자 이상 입력해주세요", message: nil)
                owner.searchviewcontroller.searchBar.rx.text.onNext(nil)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputMoveAppDetail
            .bind(with: self) { owner, value in
                let vc = ApplicationDetailViewController()
                vc.viewModel.outputApplication.onNext(value.1)
                vc.configureView(app: value.1)
                
                owner.navigationController?.pushViewController(vc, animated: true)
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
