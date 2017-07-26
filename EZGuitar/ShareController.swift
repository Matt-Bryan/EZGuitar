//
//  NewVideoController.swift
//  EZGuitar
//
//  Created by CheckoutUser on 7/24/17.
//  Copyright © 2017 MattBryan. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import FacebookCore
import FacebookLogin
import FacebookShare
import FBSDKShareKit

class ShareController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var chooseButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) != false {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = [kUTTypeImage as String]
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("UH OH")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let someImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let someURL = info[UIImagePickerControllerOriginalImage] as! UIImage
        let photo = FBSDKSharePhoto()
        photo.image = someImage
        photo.isUserGenerated = true
        
        let photoContent = FBSDKSharePhotoContent()
        
        photoContent.photos = [FBSDKSharePhoto]()
        photoContent.photos.append(photo)
        picker.dismiss(animated: true, completion: nil)
        
        FBSDKShareDialog.show(from: self, with: photoContent, delegate: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
