//
//  CameraViewController.swift
//  Snapagram
//
//  Created by RJ Pimentel on 3/11/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let image = info[.originalImage] as? UIImage {
               self.ImageView.image = image
               imagePicked = image
               SnapButton.isHidden = false


               
           }
           imagePickerController.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var ImageView: UIImageView!
    var imagePickerController :
    UIImagePickerController!
    var imagePicked : UIImage!
    var camera = true
    @IBOutlet weak var SnapButton: UIButton!
    override func viewDidLoad() {
            super.viewDidLoad()
            self.imagePickerController = UIImagePickerController()
            self.imagePickerController.delegate = self
            self.imagePickerController.sourceType = .photoLibrary
            self.ImageView.image = imagePicked
            SnapButton.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CameraButtonPressed(_ sender: Any) {
        present(imagePickerController, animated: true) {
        }
    }
    
    @IBAction func PhotoButtonPressed(_ sender: Any) {
        camera = false
        present(imagePickerController, animated: true) {
        }
    }
    
    @IBAction func SnapButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "snapping", sender: imagePicked)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PostImageViewController, let a = sender as? UIImage {
            dest.ImageToDisplay = a
        }
    }
}


