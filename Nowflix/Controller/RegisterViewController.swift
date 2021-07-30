//
//  RegisterViewController.swift
//  Nowflix
//
//  Created by APPLE on 2021-04-08.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        //register our user via FirebaseAuth
        
        
        let SuccessAlert = UIAlertController(title: "Welcome to NOWFLIX!", message: "Successfully sign up!", preferredStyle: .alert  )
        
        let SucceccAction = UIAlertAction(title: "OK", style: .default) {
            (action) in self.performSegue(withIdentifier: "showNowflixView", sender: self)
        }
        
        
        let ErrorAlert = UIAlertController(title: "Please, try again", message: "Sign up Error!", preferredStyle: .alert  )
        let ErrorAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let confirm = confirmTextField.text
//        else {return}
        else{
        
            ErrorAlert.addAction(ErrorAction)
        present(ErrorAlert, animated: true, completion: nil)
        
            return
        }
        
        if(password == confirm){
            
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Error creating firebase user: \(err)")
            } else {
                
                SuccessAlert.addAction(SucceccAction)
                
                self.present(SuccessAlert, animated: true, completion: nil)
                
                print("Successfully created user \(String(describing: user))")
            }
        }
        
    }
        
        else{
        
            ErrorAlert.addAction(ErrorAction)
        present(ErrorAlert, animated: true, completion: nil)
//            print("이거슨 액션\(action)")
            return
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
