//
//  RegisterViewController.swift
//  XtraRep
//
//  Created by Alex Waldron on 11/9/20.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(authResult, error) in
            if let e = error{
                print(e.localizedDescription)
            } else{
                self.performSegue(withIdentifier: "RegisterSegue", sender: self)
            }
        })
    }
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
