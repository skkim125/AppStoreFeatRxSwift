//
//  ITunes.swift
//  iTunesFeatRxSwift
//
//  Created by 김상규 on 8/11/24.
//

import Foundation

struct ITunes: Decodable {
    let resultCount: Int
    let results: [Application]
}

struct Application: Decodable {
    let advisories: [String] // 앱 간략 설명
    let screenshotUrls: [String] // 앱 스크린샷 url
    let artworkUrl512: String // 앱 이미지
    let releaseNotes: String? // 앱 업데이트 내역
    let description: String // 앱 설명
    let sellerName: String // 판매자 이름
    let genres: [String] // 카테고리
    let trackName: String // 앱 이름1
    let averageUserRating: Double // 평점
    let trackCensoredName: String // 앱 이름2
    let currency: String // 통화단위
    let price: Double? // 가격
    let formattedPrice: String?
    let version: String // 버전
    
    var convertPrice: Double {
        guard let price  = self.price else { return 0.00 }
        return price
    }
    
    var convertFormattedPrice: String {
        guard let formattedPrice  = self.formattedPrice else { return "무료" }
        return formattedPrice
    }
}
