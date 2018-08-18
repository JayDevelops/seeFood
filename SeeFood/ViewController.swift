//
//  ViewController.swift
//  SeeFood
//
//  Created by Jesus Perez on 8/12/18.
//  Copyright © 2018 Jesus Perez. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    //Creating th image picker controller object
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /*  Setting the properties to the right thing here for the imagePicker */
        //Making the object target to the current view controller
        imagePicker.delegate = self
        
        //Implementing the camera into any app here, the source type of the imagePicker
        imagePicker.sourceType = .camera
        
        //Making the user have an editing option for the picture they took
        imagePicker.allowsEditing = false
    }
    
    
    
    
    //MARK- PICKED MEDIA DELEGATE
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //What the user has picked or taken as a picture, the way to use their image
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //Setting up the UIImageView to the current image the user picked/took
            imageView.image = userPickedImage
            
            //Make the image readable for a core model image AKA CIImage
            guard let ciImage = CIImage(image: userPickedImage) else  {
                fatalError("Could not UIImage to a CIImage")
            }
            
            detect(image: ciImage)
        }
        
        //Dismmiss the camera view controller when the user is finsihed
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    /*Method to predict what the image is and how we get the image the user took
      Convert it into a CIImage and pass it in our InceptionV3Model */
    func detect(image: CIImage) {
        
        //creating a new model object with the method VNCoreMLModel, using this to classify our image
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                 fatalError("Model failed to process image")
            }
            
            //Gets the first strong result that the model is confident it is in
            if let firstResult = results.first  {
                
                //If the first item is confident it is a hotdog then put the title to "Hotdog"
                if firstResult.identifier.contains("hotdog")    {
                    self.navigationItem.title = "Hotdog!"
                }   else    {
                    self.navigationItem.title = "Not Hotdog!"
                }
                
            }
            
        }
        
            
            let handler = VNImageRequestHandler(ciImage: image)
            
            do  {
                try handler.perform([request])
            }   catch   {
                print(error)
            }
        
            
        }
    
    
    
    
    
    //MARK- USER TAPPED BUTTON FOR CAMERAd
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        //Present the camera when this button is pressed
        present(imagePicker, animated: true, completion: nil)
    }


}

