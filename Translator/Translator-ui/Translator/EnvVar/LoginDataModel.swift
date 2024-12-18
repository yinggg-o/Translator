//
//  LoginDataModel.swift
//  Translator
//
//  Created by suhm on 2024/11/24.
//

import Foundation
import SwiftUI
class LoginDataModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var verificationCode = ""
}
