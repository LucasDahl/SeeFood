//
//  ViewController.swift
//  SeeFood
//
//  Created by Lucas Dahl on 11/29/18.
//  Copyright © 2018 Lucas Dahl. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var identifyTextField: UITextField!
    
    // Properties
    let imagePicker = UIImagePickerController()
    let imageLibrary = UIImagePickerController()
    var identifyItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate for the imagePicker's
        imagePicker.delegate = self
        imageLibrary.delegate = self
        
        // Set allows type for the camera
        imagePicker.sourceType = .camera
        imageLibrary.sourceType = .photoLibrary
        
        // Set if the user can edit the image
        imagePicker.allowsEditing = false
        imageLibrary.allowsEditing = true
        
        // Set the placeholder text for the textField
        identifyTextField.placeholder = "Pick something to idemtify..."
        
        // This allows the textField and button to be pushed up when the keyboard is presented.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Check if an image was picked and set it the a constant
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // Set the imageView
            imageView.image = userPickedImage
            
            // Convert the UIImage to the CIImage
            guard let ciimage = CIImage(image: userPickedImage) else { fatalError("Could not convert to CIImage") }
            
            // Detect the image
            detect(image: ciimage)
            
        }
        
        // Dismiss the imagepicker
        imagePicker.dismiss(animated: true, completion: nil)
        imageLibrary.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        // This is a container for the model InceptionV3
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { fatalError("Error loading CoreML Model") }
        
        // Create a vision core request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            // Get the results
            guard let results = request.results as? [VNClassificationObservation] else { fatalError("Couldn't get the results because the MOdel failed to proces images") }
            
            // Get the first result, which should be the desired object
            if let firstResult = results.first {
                
                // Check if the first result is the desired object
                if firstResult.identifier.contains(self.identifyItem) {
                    
                    // Was the desired item
                    
                    // Set the navigationItem title to the desired item
                    self.navigationItem.title = "\(self.identifyItem)!!!!"
                    
                    
                    // Change the navigationBar tint color to red so the user clearly knows that the item is the desired item
                    self.navigationController?.navigationBar.barTintColor = .green
                    
                } else {
                    
                    // Was not the desired object
                    
                    // Set the navigationItem title to "Not desired item!"
                    self.navigationItem.title = "NOT \(self.identifyItem)!!!"
                    
                    // Change the mavigationBar tint color to red so the user knows clearly it is not the desired color.
                    self.navigationController?.navigationBar.barTintColor = .red
                    
                }
                
            }
            
        }
        
        // Get the handler for the request to specify the image want to classify
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            
            try handler.perform([request])
            
        } catch {
            
            // Print handler error
            print("Handler error: \(error)")
            
        }
        
    }
    
    //==================
    // MARK: - IBActions
    //==================

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        // Present the camera (image picker or camera)
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func photoLibraryTapped(_ sender: UIBarButtonItem) {
        
        // Present the photoLibrary
        present(imageLibrary, animated: true, completion: nil)
        
    }
    
    
    @IBAction func identifyTapped(_ sender: UIButton) {
        
        // Set the identify item to the textField
        if let newItem = identifyTextField {
            
            identifyItem = newItem.text!
            
        }
        
        // Set the textField back to nil, and clear it
        identifyTextField.text = ""
        identifyTextField.placeholder = "Pick something to idemtify..."
        
        // Dismiss the keyboard
        identifyTextField.resignFirstResponder()
        
    }
    
    //=========================
    // MARK: - Keyboard methods
    //=========================
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
} // End class


