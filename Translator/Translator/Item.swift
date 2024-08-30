//
//  Item.swift
//  Translator
//
//  Created by  Ying Liao on 11/8/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
