//
//  ViewController.swift
//  FirebaseSolo
//
//  Created by Артём Коротков on 07.09.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - var/let
    
    let segueToTask = "toTask"
    
    
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    //MARK: - Ovveride
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.alpha = 0
        
    }
    
    //MARK: - MainCode
    
    func displayWarningLabel(withText text: String) {
        warningLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations:    { [ weak self] in
            self?.warningLabel.alpha = 1
        }) { [ weak self ] complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - IBActions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarningLabel(withText: "Login or password is incorrect")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [ weak self] user, error in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueToTask)!, sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "No such user")
        }
        
    }
    
    
    
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarningLabel(withText: "Login or password is incorrect")
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [ weak self ]  user, error in
            if error == nil {
                if user != nil {
                    self?.performSegue(withIdentifier: (self?.segueToTask)!, sender: nil)
                }
            }
        }
        
        
        
        
        
    }
    
    
    
    
    
}

