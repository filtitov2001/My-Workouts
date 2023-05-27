//
//  AuthService.swift
//  My Workouts
//
//  Created by Feliks Titov on 27.05.2023.
//  Copyright © 2023 Vishal Patel. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseCore

class AuthService {
    
    static let shared = AuthService()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    func register(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard Validators.isFilled(email: email, password: password) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = email, let password = password else {
            completion(.failure(AuthError.notFilled))
            return
        }

        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }

}


class Validators {
    static func isFilled(email: String?, password: String?) -> Bool {
        guard let password = password,
              let email = email,
              password != "",
              email != "" else {
            return false
        }
        return true
    }
    
    static func isFilled(username: String?, description: String?, sex: String?) -> Bool {
        guard let username = username,
              let description = description,
              let sex = sex,
              username != "",
              description != "",
              sex != "" else {
            return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
            let emailRegEx = "^.+@.+\\..{2,}$"
            return check(text: email, regEx: emailRegEx)
        }
        
        private static func check(text: String, regEx: String) -> Bool {
            let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
            return predicate.evaluate(with: text)
        }
}

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case serverError
    case unknownError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Fill all fields!", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Email format is false!", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("The passwords do not match!", comment: "")
        case .serverError:
            return NSLocalizedString("Server error!", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error!", comment: "")
        }
    }
}
