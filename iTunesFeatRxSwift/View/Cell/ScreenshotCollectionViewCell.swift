//
//  ScreenshotCollectionViewCell.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import UIKit
import Kingfisher
import SnapKit

final class ScreenshotCollectionViewCell: UICollectionViewCell {
    static let id = "ScreenshotCollectionViewCell"
    
    private let screenShotImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(screenShotImageView)
    }
    
    private func configureLayout() {
        screenShotImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureCell(url: String) {
        guard let url = URL(string: url) else { return }
        screenShotImageView.kf.setImage(with: url)
        screenShotImageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
