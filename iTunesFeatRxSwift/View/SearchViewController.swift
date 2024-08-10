//
//  SearchViewController.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/10/24.
//

import UIKit
import RxSwift
import RxCocoa

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    private lazy var searchviewcontroller = UISearchController(searchResultsController: nil)
    private lazy var collectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.id)
        
        return cv
    }()
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        
        return layout
    }
    
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
        navigationItem.rx.title.onNext("검색")
        searchviewcontroller.searchBar.rx.placeholder.onNext("게임, 앱, 스토리 등")
    }
    
    private func configureHierarchy() {
        view.addSubview(collectionView)
    }
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
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
                    owner.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                owner.configureNavigationBar()
                owner.collectionView.rx.isHidden.onNext(true)
            }
            .disposed(by: disposeBag)
        
        searchviewcontroller.searchBar.rx.searchButtonClicked
            .bind(to: viewModel.inputSearchButtonTap)
            .disposed(by: disposeBag)
        
        searchviewcontroller.searchBar.rx.text.orEmpty
            .bind(to: viewModel.inputSearchText)
            .disposed(by: disposeBag)
        
        viewModel.outputApplications
            .bind(to: collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.id, cellType: SearchCollectionViewCell.self)) { item, value, cell in
                cell.configureCell(app: value)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputScrollToTop
            .withLatestFrom(viewModel.outputApplicationsIsEmpty)
            .bind(with: self) { owner, isEmpty in
                if !isEmpty {
                    owner.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(to: viewModel.inputIndexPath)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Application.self)
            .bind(to: viewModel.inputModel)
            .disposed(by: disposeBag)
        
        viewModel.outputApplications
            .map({ $0.isEmpty })
            .withUnretained(viewModel.outputSearchText)
            .map({ ("\($0.0)", $0.1) })
            .bind(with: self) { owner, value in
                owner.collectionView.rx.isHidden.onNext(value.1)
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
    }
    
    private func configureSearchController() {
        navigationItem.rx.searchController.onNext(searchviewcontroller)
        searchviewcontroller.searchBar.rx.searchBarStyle.onNext(.minimal)
        searchviewcontroller.searchBar.searchTextField.rx.returnKeyType.onNext(.search)
        searchviewcontroller.rx.hidesNavigationBarDuringPresentation.onNext(true)
    }
}

extension SearchViewController {
    func navigationLargeTitleModeOn() {
        navigationController?.navigationBar.rx.prefersLargeTitles.onNext(true)
        navigationItem.rx.largeTitleDisplayMode.onNext(.always)
    }
    
    func navigationLargeTitleModeOff() {
        navigationController?.navigationBar.rx.prefersLargeTitles.onNext(false)
        navigationItem.rx.largeTitleDisplayMode.onNext(.never)
    }
}
