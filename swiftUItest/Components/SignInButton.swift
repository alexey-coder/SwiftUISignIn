//
//  SignInButton.swift
//  swiftUItest
//
//  Created by Aleksey Smirnov on 14.04.2021.
//

import SwiftUI
import Combine

struct SignInButton: View {
    
    var action: (() -> Void)
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .padding(.vertical, 10)
    }
}
