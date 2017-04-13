//
//  LoginViewController.swift
//  Chat App
//
//  Created by Zensar on 17/02/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    //MARK: Variables
    var viewModel: LoginViewModel = LoginViewModel()
    
    //MARK: VIew Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyAppTheme()
        
        btnLogin.layer.cornerRadius = 5.0
        viewModel.checkUserAuthStatus()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func applyAppTheme() {
        self.view.backgroundColor = AppConstants.colorTheme.primaryColor
        self.btnLogin.setTitleColor(AppConstants.colorTheme.secondaryColor, for: .normal)
        self.btnLogin.backgroundColor = UIColor.white
        self.btnLogin.layer.cornerRadius = 5.0
    }
    //MARK: IBActions
    @IBAction func loginTapped(_ sender: Any) {
        viewModel.authUser(with: textFieldEmail.text, password: textFieldPassword.text)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            let textFieldUser = alert.textFields![0]
            let textFieldPass = alert.textFields![1]
            
            self.viewModel.signUpWith(email: textFieldUser.text, password: textFieldPass.text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    

    }
    
}
