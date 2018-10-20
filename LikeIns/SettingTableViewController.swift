//
//  SettingTableViewController.swift
//  LikeIns
//
//  Created by Roy Li on 04/09/2018.
//

import UIKit

protocol SettingTableViewControllerDelegate {
    func updateUserInfor()
}

class SettingTableViewController: UITableViewController {
    
    @IBOutlet weak var usernnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var delegate: SettingTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        usernnameTextField.delegate = self
        emailTextField.delegate = self
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        Api.User.observeCurrentUser { (user) in
            self.usernnameTextField.text = user.username
            self.emailTextField.text = user.email
            if let profileUrl = URL(string: user.profileImageUrl!) {
                self.profileImageView.sd_setImage(with: profileUrl)
            }
        }
    }
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        if let profileImg = self.profileImageView.image, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            ProgressHUD.show("Waiting...")
            AuthService.updateUserInfo(username: usernnameTextField.text!, email: emailTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Success")
                self.delegate?.updateUserInfor()
            }, onError: { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            })
        }
    }
    
    @IBAction func logoutBtn_TouchUpInside(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let startVC = storyboard.instantiateViewController(withIdentifier: "StartViewController")
            self.present(startVC, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    @IBAction func changeProfileBtn_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
}

extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension SettingTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
}
