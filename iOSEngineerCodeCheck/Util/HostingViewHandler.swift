//
//  ReloadableErrorViewHandler.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

final class HostingViewHandler<HostedViewType: View> {
    private var hostingController: UIHostingController<HostedViewType>?

    func present(to vc: UIViewController, where view: UIView, hostedView: HostedViewType) {
        guard hostingController == nil else { return }
        let hostingController = UIHostingController(rootView: hostedView)
        hostingController.view.backgroundColor = Asset.Colors.mainBackGround.color
        vc.addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.bind(to: view)
        hostingController.didMove(toParent: vc)
        self.hostingController = hostingController
    }

    func dismiss() {
        guard hostingController != nil else { return }
        hostingController?.willMove(toParent: nil)
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
}
