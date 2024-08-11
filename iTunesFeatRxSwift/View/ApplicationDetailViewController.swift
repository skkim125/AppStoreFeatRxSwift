//
//  ApplicationDetailViewController.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ApplicationDetailViewController: UIViewController {
    private let scrollView = {
        let sv = UIScrollView()
        return sv
    }()
    private let contentView = UIView()
    private let appImageView = UIImageView()
    private let applicationNameLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        
        return label
    }()
    private let downloadButton = {
        let button = UIButton(configuration: .borderedProminent())
        var configuration = button.configuration
        configuration?.baseBackgroundColor = .systemBlue
        configuration?.baseForegroundColor = .white
        configuration?.cornerStyle = .capsule
        
        button.configuration = configuration
        
        button.setTitle("받기", for: .normal)
        
        return button
    }()
    private let sellerNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        
        return label
    }()
    private let releaseLabel = {
        let label = UILabel()
        label.text = "새로운 소식"
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        
        return label
    }()
    private let releaseVersionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        
        return label
    }()
    private let releaseDetailLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        
        return label
    }()
    private lazy var screenshotCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.detailViewScreenshotCollectionViewLayout())
        cv.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotCollectionViewCell.id)
        cv.isScrollEnabled = true
        
        return cv
    }()
    
    let disposeBag = DisposeBag()
    let viewModel = ApplicationDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }
    
    private func configuration() {
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureNavigationBar() {
        navigationLargeTitleModeOff()
    }
    
    private func configureHierarchy() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        
        let views = [appImageView, applicationNameLabel, downloadButton, sellerNameLabel, releaseLabel, releaseVersionLabel, releaseDetailLabel, screenshotCollectionView]
        
        views.forEach { subView in
            contentView.addSubview(subView)
        }
    }
    
    private func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        appImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(10)
            make.leading.equalTo(contentView.snp.leading).inset(15)
            make.size.equalTo(100)
        }
        
        applicationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appImageView.snp.top).inset(10)
            make.leading.equalTo(appImageView.snp.trailing).offset(15)
            make.trailing.equalTo(contentView.snp.trailing).inset(15)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(appImageView.snp.trailing).offset(15)
            make.bottom.equalTo(appImageView.snp.bottom)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        
        sellerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(downloadButton)
            make.trailing.equalTo(contentView.snp.trailing).inset(15)
            make.bottom.equalTo(downloadButton.snp.top).offset(-5)
            make.top.equalTo(applicationNameLabel.snp.bottom)
        }
        
        releaseLabel.snp.makeConstraints { make in
            make.top.equalTo(appImageView.snp.bottom).offset(15)
            make.leading.equalTo(appImageView)
            make.trailing.equalTo(contentView.snp.trailing).inset(15)
        }
        
        releaseVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseLabel.snp.bottom).offset(10)
            make.leading.equalTo(appImageView)
            make.trailing.equalTo(contentView.snp.trailing).inset(15)
        }
        
        releaseDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseVersionLabel.snp.bottom).offset(10)
            make.leading.equalTo(appImageView)
            make.trailing.equalTo(contentView.snp.trailing).inset(15)
        }
        
        screenshotCollectionView.snp.makeConstraints { make in
            make.top.equalTo(releaseDetailLabel.snp.bottom).offset(15)
            make.leading.equalTo(appImageView)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(220)
            make.bottom.equalTo(scrollView.snp.bottom).inset(10)
        }
    }
    
    func configureView(app: Application) {
        view.backgroundColor = .systemBackground
        
        applicationNameLabel.rx.text.onNext(app.trackCensoredName)
        
        guard let url = URL(string: app.artworkUrl512) else { return }
        appImageView.contentMode = .scaleAspectFill
        appImageView.kf.setImage(with: url)
        appImageView.layer.cornerRadius = 8
        appImageView.clipsToBounds = true
        appImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        appImageView.layer.borderWidth = 0.5
        
        sellerNameLabel.rx.text.onNext(app.sellerName)
        
        releaseVersionLabel.rx.text.onNext("버전 " + app.version)
        
        releaseDetailLabel.rx.text.onNext(app.releaseNotes)
        
        bind(app: app)
    }
    
    private func bind(app: Application) {
        var threeSs: [String] = []
        for i in 0...2 {
            threeSs.append(app.screenshotUrls[i])
        }
        let outputScreenshotUrls = BehaviorSubject(value: threeSs)
        
        outputScreenshotUrls
            .bind(to: screenshotCollectionView.rx.items(cellIdentifier: ScreenshotCollectionViewCell.id, cellType: ScreenshotCollectionViewCell.self)) { item, value, cell in
                
                cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                cell.layer.borderWidth = 0.3
                cell.layer.cornerRadius = 8
                cell.clipsToBounds = true
                cell.configureCell(url: value)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        configureNavigationBarSearchAppearance()
    }
}
