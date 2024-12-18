import Foundation
import SwiftUI

// API配置管理器，用于集中管理和动态更新API地址
class APIConfigManager: ObservableObject {
    // 单例模式，全局唯一实例
    static let shared = APIConfigManager()
    
    // 基础服务器地址，使用@Published支持响应式更新
    @Published var baseURL: String = "http://172.20.5.174:8081"
    
    // 私有构造函数，确保单例模式
    private init() {}
    
    // 注册相关 API 端点    
    var registerSendVerificationCode: String { "\(baseURL)/smsCode" }
    var registerUser: String { "\(baseURL)/register" }
    var generateCaptcha: String { "\(baseURL)/generateCaptcha" }
    var updatePassword: String { "\(baseURL)/updatePassWord" }
    
    // 登录相关 API 端点
    var loginEndpoint: String { "\(baseURL)/login" }
    
    // 文章管理相关 API 端点
    var articleFetchText: String { "\(baseURL)/fetchtext" }
    var articleUploadText: String { "\(baseURL)/uploadText" }
    var articleGetByBelong: String { "\(baseURL)/getArticleByBelong" }
    
    // 翻译对比卡片 API 端点
    
    var translationAddTranslate : String{"\(baseURL)/translation/history/addTranslate"}
    // 翻译相关 API 端点
    var translationHistorySearch: String { "\(baseURL)/translation/history/search" }
    
    // 动态更新基础服务器地址的方法
    func updateBaseURL(_ newURL: String) {
        baseURL = newURL
    }
}
