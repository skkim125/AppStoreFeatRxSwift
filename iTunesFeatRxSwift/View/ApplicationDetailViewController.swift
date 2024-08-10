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
        let views = [appImageView, applicationNameLabel, downloadButton, sellerNameLabel]
        
        views.forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func configureLayout() {
        appImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.size.equalTo(120)
        }
        
        applicationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appImageView.snp.top).inset(10)
            make.leading.equalTo(appImageView.snp.trailing).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(appImageView.snp.trailing).offset(15)
            make.bottom.equalTo(appImageView.snp.bottom)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        
        sellerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(downloadButton)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(downloadButton.snp.top).offset(-5)
            make.height.equalTo(20)
            make.top.equalTo(applicationNameLabel.snp.bottom)
        }
    }
    
    func configureView(app: Application) {
        view.backgroundColor = .systemBackground
        
        applicationNameLabel.rx.text.onNext(app.trackCensoredName)
        guard let url = URL(string: app.artworkUrl512) else { return }
        appImageView.kf.setImage(with: url)
        appImageView.layer.cornerRadius = 8
        appImageView.clipsToBounds = true
        sellerNameLabel.rx.text.onNext(app.sellerName)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        configureNavigationBarSearchAppearance()
    }
}
