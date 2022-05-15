//
//  ReloadableErrorViewHandler.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Extensions
import Foundation
import Resources
import SwiftUI
import UIKit

public final class HostingViewHandler<HostedViewType: View> {
    private var hostingController: UIHostingController<HostedViewType>?

    public init() {}

    /// SwiftUIで作成したViewを指定の場所に表示する
    /// - Parameters:
    ///   - vc: 表示するViewController
    ///   - view: ViewController上のView。このViewと同じ位置に表示する
    ///   - hostedView: 表示するSwiftUI製のView
    public func present(to vc: UIViewController, where view: UIView, hostedView: HostedViewType) {
        guard hostingController == nil else { return }
        let hostingController = UIHostingController(rootView: hostedView)
        hostingController.view.backgroundColor = Asset.Colors.mainBackGround.color
        vc.addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.bind(to: view)
        hostingController.didMove(toParent: vc)
        self.hostingController = hostingController
    }

    /// SwiftUIで作成したViewを消す
    public func dismiss() {
        guard hostingController != nil else { return }
        hostingController?.willMove(toParent: nil)
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}
