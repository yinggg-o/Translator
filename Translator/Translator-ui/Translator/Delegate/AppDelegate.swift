//
//  AppDelegate.swift
//  Translator
//
//  Created by suhm on 2024/11/25.
//

import Cocoa
import SwiftUI

//@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var userLoginStatus: UserLoginStatus!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 创建窗口
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 800, height: 600), styleMask: [.titled,.closable,.miniaturizable,.resizable], backing:.buffered, defer: false)

        // 初始化用户登录状态实例
        userLoginStatus = UserLoginStatus()

        // 设置窗口的初始视图为TranslatorView，并将用户登录状态传递给它
        let translatorView = TranslatorView()
        let hostingController = NSHostingController(rootView: translatorView)
        window.contentViewController = hostingController

        window.makeKeyAndOrderFront(nil)
    }
}
