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
    
    // Properties
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate for the imagePicker
        imagePicker.delegate = self
        
        // Set allows type for the camera
        imagePicker.sourceType = .camera
        
        // Set if the user can edit the image
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Check if an image was picked and set it the a constant
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // Set the imageView
            imageView.image = userPickedImage
            
        }
        
        // Dismiss the imagepicker
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        // Present the camera VC(image picker or camera)
        present(imagePicker, animated: true, completion: nil)
        
    }
    
} // End class

