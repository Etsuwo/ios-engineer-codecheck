//
//  ReloadableErrorView.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

protocol ReloadableErrorViewModelProtocol {
    func reload()
}

struct ReloadableErrorView: View {
    let viewModel: ReloadableErrorViewModelProtocol

    var body: some View {
        VStack {
            Image(uiImage: Asset.Images.geranium.image)
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
            Spacer()
                .frame(height: 40)
            Button(action: {
                viewModel.reload()
            }, label: {
                Text("再読み込み")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 56, alignment: .center)
                    .background(Color(Asset.Colors.mainBlack.color))
                    .cornerRadius(8)
            })
        }
    }
}
