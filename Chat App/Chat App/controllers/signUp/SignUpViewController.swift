//
//  SignUpViewController.swift
//  Chat App
//
//  Created by Zensar on 15/03/17.
//  Copyright © 2017 Zensar. All rights reserved.
//

import UIKit
import Photos
import Firebase

class SignUpViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    
    //MARK: Variables
    let viewModel: SignUpViewModel = SignUpViewModel()
    let picker = UIImagePickerController()
    var photoReferenceUrl: URL?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.imageTapped))
        self.imageViewProfilePic.addGestureRecognizer(tapGesture)
        self.imageViewProfilePic.isUserInteractionEnabled = true
        
        picker.delegate = self
    }

    override func viewWillLayoutSubviews() {
        applyAppTheme()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IBActions
    @IBAction func submitTapped(_ sender: Any) {
        guard let email = textFieldEmail.text, let password = textFieldPassword.text, let confirmPassword = textFieldConfirmPassword.text, let name = textFieldName.text else {
            Utils.showAlert(with: "Error", message: "Details not complete or password did not match")
            return
        }
        
        if password == confirmPassword {
            
            viewModel.signUpWith(email: email, password: password, name: name)
            if let photoReferenceUrl = self.photoReferenceUrl {
                viewModel.uploadImage(email: email, photoReferenceUrl: photoReferenceUrl)
            }
           
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: User defined methods
    func applyAppTheme() {
        self.view.backgroundColor = AppConstants.colorTheme.primaryColor
        
        self.btnSignUp.setTitleColor(AppConstants.colorTheme.secondaryColor, for: .normal)
        self.btnSignUp.backgroundColor = UIColor.white
        self.btnSignUp.layer.cornerRadius = 5.0
        
        self.btnCancel.setTitleColor(UIColor.white, for: .normal)
        
        self.imageViewProfilePic.layer.cornerRadius = self.imageViewProfilePic.frame.size.height / 2
        self.imageViewProfilePic.clipsToBounds = true
    }
    
    func imageTapped() {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: ImagePicker Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageViewProfilePic.contentMode = .scaleAspectFit
        imageViewProfilePic.image = chosenImage
        dismiss(animated:true, completion: nil)
        
        self.photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL

    }
}
