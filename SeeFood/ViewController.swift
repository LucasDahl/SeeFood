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
            
            // Convert the UIImage to the CIImage
            guard let ciimage = CIImage(image: userPickedImage) else { fatalError("Could not convert to CIImage") }
            
            // Detect the image
            detect(image: ciimage)
            
        }
        
        // Dismiss the imagepicker
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        // This is a container for the model InceptionV3
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { fatalError("Error loading CoreML Model") }
        
        // Create a vision core request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            // Get the results
            guard let results = request.results as? [VNClassificationObservation] else { fatalError("Couldn't get the results because the MOdel failed to proces images") }
            
            print(results)
            
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

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        // Present the camera VC(image picker or camera)
        present(imagePicker, animated: true, completion: nil)
        
    }
    
} // End class

