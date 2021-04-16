//
//  ContentView.swift
//  swiftUItest
//
//  Created by Aleksey Smirnov on 14.04.2021.
//

import SwiftUI
import Combine
import Foundation

struct SignUpView: View {
    
    @ObservedObject private var viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            LabelTextField(
                labelAbove: viewModel.loginTitle,
                placeHolder: viewModel.loginPlaceHolder,
                textValue: $viewModel.login,
                errorValue: viewModel.loginError)
            LabelTextField(
                labelAbove: viewModel.passwordTitle,
                placeHolder: viewModel.passwordPlaceholder,
                isSecured: true,
                textValue: $viewModel.password,
                errorValue: viewModel.passwordError)
            LabelTextField(
                labelAbove: viewModel.confirmPasswordTitle,
                placeHolder: viewModel.repeatPasswordPlaceholder,
                isSecured: true,
                textValue: $viewModel.confirmPassword,
                errorValue: viewModel.confirmPasswordError)
            SignInButton(action: viewModel.signUpAction)
                .disabled(!viewModel.signUpIsEnabled)
                .background(viewModel.signUpIsEnabled ? Color.red : Color.gray)
                .padding(.top, 50)
        }
        .padding(40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel())
    }
}
