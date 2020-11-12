//
//  RegisterViewController.swift
//  XtraRep
//
//  Created by Alex Waldron on 11/9/20.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text, let name = nameTextField.text {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(authResult, error) in
            if let e = error{
                print(e.localizedDescription)
            } else{
                self.db.collection("users").document(name).setData(["emailAddress":email], merge: true)
                
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
