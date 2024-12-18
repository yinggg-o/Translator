//
//  CaptchaManager.swift
//  Translator
//
//  Created by suhm on 2024/11/28.
//

import Alamofire
import Foundation
import SwiftUI


// CaptchaManager类用于管理验证码相关的操作，如获取验证码图片和提取验证码相关信息
class CaptchaManager: ObservableObject {

    // 用于存储获取到的验证码图片，以便在其他地方使用
    @Published var captchaImage: Image?

    // 用于存储从验证码数据中提取到的captchaCode
    @Published var captchaCode: String = ""

    // 用于存储从验证码数据中提取到的captchaKey
    @Published var captchaKey: String = ""

    // 获取验证码图片及相关信息的函数
    func getImageCode() {
        AF.request(APIConfigManager.shared.generateCaptcha, method:.get, encoding: URLEncoding.default)
        .responseData { response in
                switch response.result {
                case.success(let value):
                    // 处理获取到的验证码图片数据及提取相关信息
                    self.handleCaptchaData(data: value)
                case.failure(let error):
                    print("Error: \(error)")
                }
            }
    }

    // 处理获取到的验证码数据的私有函数
    private func handleCaptchaData(data: Data) {
        // 尝试将获取到的二进制数据转换为NSImage，再转换为SwiftUI的Image类型
        if let image = NSImage(data: data) {
            let swiftUIImage = Image(nsImage: image)
            self.captchaImage = swiftUIImage
        }

        let dataLength = data.count
        if dataLength >= 200 {
            // 提取captchaCode及相关信息处理
            self.extractCaptchaCode(from: data)
        } else {
            print("数据长度不足，无法进行从倒数第109位到倒数第1位的切片操作")
        }
    }

    // 从数据中提取captchaCode及相关信息的私有函数
    private func extractCaptchaCode(from data: Data) {
        // 计算倒数第109位和倒数第1位对应的正向索引（这里按照正确逻辑修正了之前可能错误的索引计算表述）
        let indexFromEnd109 = data.count - 112
        let indexFromEnd1 = data.count

        // 进行切片操作，切片范围是 [indexFromEnd109..<indexFromEnd1]
        let slicedData = data[indexFromEnd109..<indexFromEnd1]
        print("切片数据（从倒数第109位到倒数第1位）: \(slicedData)")

        // 将切片数据转换为字符串
        if let stringFromSlice = String(data: slicedData, encoding:.utf8) {
            print("转换后的字符串数据: \(stringFromSlice)")

            do {
                // 将字符串数据转换为JSON数据
                if let jsonData = try JSONSerialization.jsonObject(with: stringFromSlice.data(using:.utf8)!, options: []) as? [String: Any] {
                    // 这里假设你有一个变量来存储转换后的JSON数据，比如下面的 jsonResult
                    let jsonResult = jsonData
//                    print("转换后的JSON数据: \(jsonResult)")

                    // 处理从JSON数据中获取captchaCode和captchaKey的值
                    self.handleCaptchaCodeAndKey(from: jsonResult)
                } else {
                    print("字符串数据无法转换为JSON格式的字典数据")
                }
            } catch {
                print("将字符串数据转换为JSON时出错: \(error)")
            }
        } else {
            print("无法将切片数据转换为UTF-8编码的字符串")
        }
    }

    // 处理从JSON数据中获取captchaCode和captchaKey的值的私有函数
    private func handleCaptchaCodeAndKey(from jsonResult: [String: Any]) {
        // 假设这里的jsonResult是已经正确转换好的JSON数据，类型为 [String: Any]
        if let dataDict = jsonResult["data"] as? [String: Any] {
            // 尝试获取captchaCode的值
            if let captCode = dataDict["captchaCode"] as? String {
                print("JSON数据中 'captchaCode' 的值: \(captCode)")
                self.captchaCode = captCode
            } else {
                print("JSON数据中 'data' 字典下不存在 'captchaCode' 键或其值类型不是String")
            }

            // 尝试获取captchaKey的值
            if let captKey = dataDict["captchaKey"] as? String {
                print("JSON数据中 'captchaKey' 的值: \(captKey)")
                self.captchaKey = captKey
            } else {
                print("JSON数据中 'data' 字典下不存在 'captchaKey' 键或其值类型不是String")
            }
        } else {
            print("JSON数据中不存在 'data' 键或其值类型不是字典")
        }
    }
}
