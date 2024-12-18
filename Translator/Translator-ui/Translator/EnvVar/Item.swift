//
//  Item.swift
//  Translator
//
//  Created by  Ying Liao on 11/8/2024.
//

import Foundation
// 定义与之前类似的Item类，但去掉SwiftData相关的标注
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

// 扩展Item类以实现Codable协议，以便能进行编码和解码操作
extension Item: Codable {}

// 用于存储Item数据到UserDefaults的函数
func storeItemInUserDefaults(item: Item) {
    do {
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(item)
        UserDefaults.standard.set(encodedData, forKey: "storedItem")
    } catch {
        print("存储Item数据到UserDefaults时出错: \(error)")
    }
}

// 用于从UserDefaults读取Item数据的函数
func retrieveItemFromUserDefaults() -> Item? {
    if let data = UserDefaults.standard.data(forKey: "storedItem") {
        do {
            let decoder = JSONDecoder()
            let retrievedItem = try decoder.decode(Item.self, from: data)
            return retrievedItem
        } catch {
            print("从UserDefaults读取Item数据时出错: \(error)")
            return nil
        }
    }
    return nil
}

