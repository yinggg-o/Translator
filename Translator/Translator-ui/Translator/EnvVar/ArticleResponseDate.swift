//
//  ArticleResponseDate.swift
//  Translator
//
//  Created by suhm on 2024/11/28.
//

import Foundation
// 对应API返回的整个数据结构
struct ArticleSearchAPIResponse: Decodable {
    let code: Int
    let msg: String
    let data: [ArticleAPI]
}

// 对应API返回数据中的每个文章数据结构
struct ArticleAPI: Decodable {
    let id: Int
    let sourceText: String
    let targetText: String
    let userId: Int
    let uploadTime: String
    let belong: String
}
