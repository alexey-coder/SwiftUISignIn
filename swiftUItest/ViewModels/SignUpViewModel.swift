//
//  SignUpViewModel.swift
//  swiftUItest
//
//  Created by Aleksey Smirnov on 14.04.2021.
//


import Combine
import SwiftUI

//● passwords in both text fields must match
//● password length must be greater than 8 chars
//● the following well-known passwords must be explicitly prohibited: "password", "admin"
//● user name must be valid according to the response from the server
//○ do not send very frequent requests to the server, debounce time must be 500 ms
//○ do not request duplicate values
//● enable Create Account button only if all the above requirements are met.

final class SignUpViewModel: ObservableObject {
    
    let loginTitle = "login"
    let loginPlaceHolder = "type login"
    @Published var login: String = ""
    @Published var loginError: String = ""
    
    let passwordTitle = "password"
    let passwordPlaceholder = "type password"
    @Published var password: String = ""
    @Published var passwordError: String = ""
    
    let confirmPasswordTitle = "confirm password"
    let repeatPasswordPlaceholder = "repeat password"
    @Published var confirmPassword: String = ""
    @Published var confirmPasswordError: String = ""
    
    @Published var signUpIsEnabled: Bool = false
    
    private let server = FakeServer()
    private var cancellables = Set<AnyCancellable>()
    
    ///Login
    private var loginValidPublisher: AnyPublisher<(login: String, isValid: Bool), Never> {
        return $login
            .map { ($0, !$0.isEmpty) }
            .eraseToAnyPublisher()
    }
    
    ///Password
    private var passwordRequiredPublisher: AnyPublisher<(password: String, isValid: Bool), Never> {
        return $password
            .map {(password: $0, isValid: !$0.isEmpty) }
            .eraseToAnyPublisher()
    }
    
    private var passwordLengthCheckPublisher: AnyPublisher<(password: String, isValid: Bool), Never> {
        return passwordRequiredPublisher
            .filter { $0.isValid }
            .map { [self] in (password: $0.password, isValid: passwordLengthCheck(password: $0.password)) }
            .eraseToAnyPublisher()
    }
    
    private var dummyPasswordCheckPublisher: AnyPublisher<(password: String, isValid: Bool), Never> {
        return passwordLengthCheckPublisher
            .filter { $0.isValid }
            .map { [self] in (password: $0.password, isValid: dummyPasswordCheck(password: $0.password)) }
            .eraseToAnyPublisher()
    }
    
    /// Confirm password
    private var confirmPasswordRequiredPublisher: AnyPublisher<(password: String, isValid: Bool), Never> {
        return $confirmPassword
            .map { (password: $0, isValid: !$0.isEmpty )}
            .eraseToAnyPublisher()
    }
    
    private var confirmPasswordLengthCheckPublisher: AnyPublisher<(password: String, isValid: Bool), Never> {
        return confirmPasswordRequiredPublisher
            .filter { $0.isValid }
            .map { [self] in (password: $0.password, isValid: passwordLengthCheck(password: $0.password)) }
            .eraseToAnyPublisher()
    }
    
    private var dummyConfirmPasswordCheckPublisher: AnyPublisher<(password: String, isValid: Bool), Never> {
        return confirmPasswordLengthCheckPublisher
            .filter { $0.isValid }
            .map { [self] in (password: $0.password, isValid: dummyPasswordCheck(password: $0.password)) }
            .eraseToAnyPublisher()
    }
    
    private var passwordEqualPublisher: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($password, $confirmPassword)
            .filter { !$0.0.isEmpty && !$0.1.isEmpty }
            .map { password, confirmPassword in
                return password == confirmPassword
            }
            .eraseToAnyPublisher()
    }
    
    /// Server Login check
    private var serverLoginCheckPublisher: AnyPublisher<Bool, Never> {
        return loginValidPublisher
            .filter { $0.isValid }
            .map { $0.login }
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [server] in server.checkAvalibilityOf(login: $0) }
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    init() {
        loginValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0.isValid ? "" : "We need your login" }
            .assign(to: \.loginError, on: self)
            .store(in: &cancellables)
        
        passwordRequiredPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0.isValid ? "" : "Password is missing" }
            .assign(to: \.passwordError, on: self)
            .store(in: &cancellables)
        
        passwordLengthCheckPublisher
            .receive(on: RunLoop.main)
            .map { $0.isValid ? "" : "Password must be greater than 8 chars" }
            .assign(to: \.passwordError, on: self)
            .store(in: &cancellables)
        
        dummyPasswordCheckPublisher
            .receive(on: RunLoop.main)
            .map { $0.isValid ? "" : "Dummy password" }
            .assign(to: \.passwordError, on: self)
            .store(in: &cancellables)
        
        confirmPasswordRequiredPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map { $0.isValid ? "" : "Confirm Password is missing" }
            .assign(to: \.confirmPasswordError, on: self)
            .store(in: &cancellables)
        
        confirmPasswordLengthCheckPublisher
            .receive(on: RunLoop.main)
            .map { $0.isValid ? "" : "Password must be greater than 8 chars" }
            .assign(to: \.confirmPasswordError, on: self)
            .store(in: &cancellables)
        
        dummyConfirmPasswordCheckPublisher
            .receive(on: RunLoop.main)
            .map { $0.isValid ? "" : "Dummy password" }
            .assign(to: \.confirmPasswordError, on: self)
            .store(in: &cancellables)
        
        passwordEqualPublisher
            .receive(on: RunLoop.main)
            .map { $0 ? "" : "Passwords not match" }
            .assign(to: \.confirmPasswordError, on: self)
            .store(in: &cancellables)
        
        serverLoginCheckPublisher
            .receive(on: RunLoop.main)
            .map { $0 ? "" : "Login too short" }
            .assign(to: \.loginError, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest(serverLoginCheckPublisher, passwordEqualPublisher)
            .map { login, pass in
                return login && pass
            }
            .receive(on: RunLoop.main)
            .assign(to: \.signUpIsEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func signUpAction() -> Void {
        print("account has been created!")
    }
    
    private let prohibitedPasswords = ["password", "admin"]
    private let minNumsOfPassword = 8
    
    private func passwordLengthCheck(password: String) -> Bool {
        return password.count > minNumsOfPassword
    }
    
    private func dummyPasswordCheck(password: String) -> Bool {
        return !prohibitedPasswords.contains(password)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

