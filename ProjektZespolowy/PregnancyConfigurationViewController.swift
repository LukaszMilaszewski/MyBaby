//
//  PregnancyConfigurationViewController.swift
//  ProjektZespolowy
//
//  Created by Lukasz Milaszewski on 26/04/17.
//  Copyright © 2017 Lukasz Milaszewski. All rights reserved.
//
import Foundation
import UIKit

class PregnancyConfigurationViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var photoURL: URL {
        let filename = "MotherPhoto.jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var image: UIImage?
    
    @IBAction func Done() {
        UserDefaults.standard.set(true, forKey: "PregnantFirstRun")
        UserDefaults.standard.set(nameTextField.text!, forKey: "PregnancyName")
        UserDefaults.standard.set(timeTextField.text!, forKey: "PregnancyTime")
        if image != nil {
       	 if let data = UIImageJPEGRepresentation(image!, 0.5) {
            do {
                try data.write(to: photoURL, options: .atomic)
            } catch {
            }
        }
        }
        let time = Int(timeTextField.text!)
        if !(nameTextField.text?.isEmpty)! && !(timeTextField.text?.isEmpty)! && time! <= 40  {
    		performSegue(withIdentifier: "Pregnant", sender: nil)
        }
    }
    
    @IBAction func choosePhoto() {
        pickPhoto()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeTextField.keyboardType = UIKeyboardType.numberPad
        self.nameTextField.delegate = self
        
        tableView.allowsSelection = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath != nil && indexPath!.section == 1 && indexPath!.row == 0 {
            return
        }
        timeTextField.resignFirstResponder()
    }
    
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        imageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
        addPhoto.isHidden = true
        
        // dla zaokraglonych zdjec :)
        
       	 // imageView.layer.cornerRadius = imageView.frame.size.width/2
    	//  imageView.clipsToBounds = true
    }
}


extension PregnancyConfigurationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Anuluj", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Zrob zdjecie", style: .default, handler: { _ in self.takePhotoWithCamera() })
        alertController.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Wybierz z galerii", style: .default, handler: { _ in self.choosePhotoFromLibrary() })
        alertController.addAction(chooseFromLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
