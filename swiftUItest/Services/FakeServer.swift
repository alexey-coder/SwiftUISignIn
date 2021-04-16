//
//  FakeServer.swift
//  swiftUItest
//
//  Created by Aleksey Smirnov on 15.04.2021.
//

import Foundation
import Combine

//○ simulate server response locally by any asynchronous means, like Future and
//promise closure, for example
//○ 'server side' logic of the username check must simply prohibit names that are
//shorter than 5 chars, somewhat like this:
//func usernameAvailable(_ username: String, completion: (Bool) -> Void) {
//username.count < 5 ? completion(false) : completion(true) }

final class FakeServer {
        
    func checkAvalibilityOf(login: String) -> Future<Bool, Never> {
        return Future<Bool, Never> { promise in
            if login.count > 5 {
                promise(.success(true))
                return
            }
            promise(.success(false))
        }
    }
}
