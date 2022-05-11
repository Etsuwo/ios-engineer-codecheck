//
//  TableView+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    func removeHighlight(animated: Bool = true) {
        if let selectedRow = indexPathForSelectedRow {
            deselectRow(at: selectedRow, animated: animated)
        }
    }
}
