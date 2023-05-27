//
//  AuthViewController.swift
//  My Workouts
//
//  Created by Feliks Titov on 27.05.2023.
//  Copyright © 2023 Felix Titov. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var changeStateButton: UIButton!
    
    private var isSignIn = true
    
    
    @IBAction func forgotDataTapped(_ sender: UIButton) {
        showAlert(with: "Ooops!", and: "This button is just for test!")
        
    }
    
    
    @IBAction func logInAction() {
        if isSignIn {
            AuthService.shared.login(email: emailTF.text, password: passwordTF.text) { result in
                switch result {
                case .success(let user):
//                   self.showAlert(with: "Success!", and: "You've signed in!")
//                        FirestoreService.shared.getUserData(user: user) { result in
//                            switch result {
//
//                            case .success(let mUser):
//                                let mainTabBarController = MainTabBarController(currentUser: mUser)
//                                mainTabBarController.modalPresentationStyle = .fullScreen
//                                self.present(mainTabBarController, animated: true)
//                            case .failure(_):
//                                self.present(SetupProfileViewController(currentUser: user), animated: true)
//                            }
//                        }

                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
                    self.present(vc, animated: true)
                        
                    
                case .failure(let error):
                    self.showAlert(with: "Error!", and: error.localizedDescription)
                }
            }
        } else {
            AuthService.shared.register(email: emailTF.text, password: passwordTF.text) { result in
                switch result {
                    
                case .success(let user):
//                    self.showAlert(with: "Success!", and: "You've signed up!")
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
                    self.present(vc, animated: true)
                case .failure(let error):
                    self.showAlert(with: "Error!", and: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func changeState() {
        if isSignIn {
            changeStateButton.setTitle("Already have account? Sign In", for: .normal)
            loginButton.setTitle("Sign Up", for: .normal)
            
        } else {
            changeStateButton.setTitle("Don't have account? Sign Up", for: .normal)
            loginButton.setTitle("Sign In", for: .normal)
        }
        forgotButton.isHidden = isSignIn
        isSignIn.toggle()
    }
}

// MARK: - Private methods
extension AuthViewController {
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.passwordTF.text = ""
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Work with keyboard
extension AuthViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            logInAction()
        }
        
        return true
    }
    
}
