//
//  UserLoginStatus.swift
//  Translator
//
//  Created by suhm on 2024/11/25.
//

import Foundation
import Combine

// 用户登录状态的类，遵循ObservableObject协议以便能被视图观察到状态变化
class UserLoginStatus: ObservableObject {
    @Published var isLoggedIn: Bool = false
    // 新增属性用于存储登录ID
    @Published var loginId: Int?
    // 新增属性用于存储tokenName
    @Published var tokenName: String?
    // 新增属性用于存储tokenValue

    @Published var tokenValue: String?
}
	
	
