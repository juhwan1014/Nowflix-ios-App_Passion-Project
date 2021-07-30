//
//  ViewController.swift
//  Nowflix
//
//  Created by APPLE on 2021-04-08.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text
        else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                
                let alert = UIAlertController(title: "Please, try again", message: "Sign up Error!", preferredStyle: .alert  )
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
                print("Error logging in firebase user: \(err)")
            } else{
                
                let alert = UIAlertController(title: "Welcome to NOWFLIX!", message: "Successfully sign in!", preferredStyle: .alert  )
                
                let SucceccAction = UIAlertAction(title: "OK", style: .default) {
                    (action) in self.performSegue(withIdentifier: "showNowflixView", sender: self)
                }
                
                alert.addAction(SucceccAction)
                
                self.present(alert, animated: true, completion: nil)
                
                print("Successfully logged in user \(String(describing: user))")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }


}

