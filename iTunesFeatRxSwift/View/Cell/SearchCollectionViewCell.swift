//
//  SearchCollectionViewCell.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift
import RxCocoa

final class SearchCollectionViewCell: UICollectionViewCell {
    static let id = "SearchCollectionViewCell"
    
    private let appImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let downloadButton = {
        let button = UIButton(configuration: .borderedProminent())
        var configuration = button.configuration
        configuration?.baseBackgroundColor = .systemGray3
        configuration?.baseForegroundColor = .systemBlue
        configuration?.cornerStyle = .capsule
        
        button.configuration = configuration
        
        button.setTitle("받기", for: .normal)
        
        return button
    }()
    private let rateImageView = {
        let iv = UIImageView(image: UIImage(systemName: "star.fill"))
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    private let rateLabel = UILabel()
    private let sellerNameLabel = UILabel()
    private let categoryLabel = UILabel()
    
    private var disposeBag = DisposeBag()
    
    private lazy var screenshotCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.screenshotCollectionViewLayout())
        cv.register(ScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenshotCollectionViewCell.id)
        
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        let views = [appImageView, appNameLabel, downloadButton, rateImageView, rateLabel, sellerNameLabel, categoryLabel, screenshotCollectionView]
        
        views.forEach { contentView.addSubview($0) }
    }
    private func configureLayout() {
        appImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(50)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(appImageView.snp.trailing).offset(10)
            make.centerY.equalTo(appImageView)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(appNameLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.centerY.equalTo(appImageView)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        
        rateImageView.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.leading.equalTo(appImageView)
            make.top.equalTo(appImageView.snp.bottom).offset(10)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rateImageView)
            make.leading.equalTo(rateImageView.snp.trailing).offset(5)
        }
        
        sellerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(appImageView.snp.trailing).offset(10)
            make.centerX.equalTo(appNameLabel)
            make.centerY.equalTo(rateImageView)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.trailing.equalTo(downloadButton)
            make.centerY.equalTo(rateImageView)
            make.leading.equalTo(sellerNameLabel.snp.trailing).offset(10)
        }
        
        screenshotCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sellerNameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
    }
    func configureCell(app: Application) {
        guard let url = URL(string: app.artworkUrl512) else { return }
        appImageView.kf.setImage(with: url)
        appImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        appImageView.layer.borderWidth = 0.5
        appImageView.clipsToBounds = true
        
        appNameLabel.text = app.trackCensoredName
        
        rateLabel.text = String(format: "%.1f", app.averageUserRating)
        rateLabel.textColor = .gray
        rateLabel.font = .systemFont(ofSize: 12)
        
        sellerNameLabel.text = app.sellerName
        sellerNameLabel.textColor = .gray
        sellerNameLabel.font = .systemFont(ofSize: 12)
        sellerNameLabel.textAlignment = .center
        
        categoryLabel.text = app.genres.first ?? ""
        categoryLabel.textColor = .gray
        categoryLabel.font = .systemFont(ofSize: 12)
        categoryLabel.textAlignment = .right
        screenshotCollectionView.isScrollEnabled = false
        
        downloadButton.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        
        bind(app: app)
    }
    
    @objc func downloadButtonClicked() {
        print("버튼 클릭됨")
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        appImageView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
