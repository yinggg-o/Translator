import Cocoa
import SwiftUI

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
    }

    init(window: NSWindow) {
        super.init(window: window)

        // 设置窗口背景颜色为白色
        window.backgroundColor = NSColor.white
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // 切换到HomeView并清空当前视图内容
    func showHomeView() {
        if let currentViewController = contentViewController {
            // 移除当前视图控制器的所有子视图
            currentViewController.view.subviews.forEach { $0.removeFromSuperview() }

            // 移除当前视图控制器与父视图控制器的关系（如果有）
            if let parentViewController = currentViewController.parent {
                currentViewController.removeFromParent()
            }

            let homeView = HomeView()
            let hostingController = NSHostingController(rootView: homeView)
            contentViewController = hostingController
        }
    }
}
