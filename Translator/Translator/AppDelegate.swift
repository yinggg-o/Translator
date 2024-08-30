//
//  AppDelegate.swift
//  Translator
//
//  Created by  Ying Liao on 30/8/2024.
//

import Foundation
import Cocoa
import SwiftUI



class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var window: NSWindow!
    
    

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()

        // Create the window and set the content view
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 250),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
        // Make the window floating
        window.level = .floating
        
        // Set the window's background to be transparent
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        
        // Set the window's alpha value to 50% transparency
        window.alphaValue = 0.5
    }
}


