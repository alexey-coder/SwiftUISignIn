//
//  LabelTextField.swift
//  swiftUItest
//
//  Created by Aleksey Smirnov on 14.04.2021.
//

import Foundation
import SwiftUI
import Combine

struct LabelTextField: View {
    var labelAbove: String
    var placeHolder: String
    var isSecured: Bool = false
    
    @Binding var textValue: String
    var errorValue: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(labelAbove)
                .font(.headline)
            if isSecured {
                SecureField(placeHolder, text: $textValue)
                    .padding(.all)
                    .keyboardType(.default)
                    .background(Color.gray.opacity(0.5))
            } else {
                TextField(placeHolder, text: $textValue)
                    .padding(.all)
                    .keyboardType(.default)
                    .background(Color.gray.opacity(0.5))
            }
            Text(errorValue)
                .fontWeight(.light)
                .foregroundColor(.red)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .trailing)
        }
    }
}
