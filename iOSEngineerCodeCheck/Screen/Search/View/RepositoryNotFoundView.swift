//
//  RepositoryNotFoundView.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

struct RepositoryNotFoundView: View {
    var body: some View {
        Image(uiImage: Asset.Images.rosemarry.image)
            .resizable()
            .scaledToFit()
            .frame(width: 240, height: 240)
            .accessibilityIdentifier("repositoryNotFoundView")
    }
}
