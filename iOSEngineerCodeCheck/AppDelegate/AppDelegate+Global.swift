//
//  AppDelegate+Global.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    func setupAppNavigationController() {
        let color = UIColor.white
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.titleTextAttributes = [.foregroundColor: Asset.Colors.mainBlack.color]
        UINavigationBar.appearance().tintColor = Asset.Colors.subBlack.color
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
}
