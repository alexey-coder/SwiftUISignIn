//
//  swiftUItestApp.swift
//  swiftUItest
//
//  Created by Aleksey Smirnov on 14.04.2021.
//

import SwiftUI

@main
struct swiftUItestApp: App {
    var body: some Scene {
        WindowGroup {
            SignUpView(viewModel: SignUpViewModel())
        }
    }
}
