//
//  ViewController.swift
//  MemeMe
//
//  Created by Benjamin Clark  on 10/17/15.
//  Copyright (c) 2015 Benjamin Clark . All rights reserved.
//

import UIKit

    
    
    class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate{
        
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var topText: UITextField!
        @IBOutlet weak var bottomText: UITextField!
        
        @IBOutlet weak var toolBar: UIToolbar!
        @IBOutlet weak var cameraButton: UIBarButtonItem!
        
        @IBOutlet weak var beginLabel: UILabel!
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
            NSStrokeWidthAttributeName : -4.0
        ]
        
        
    override func viewDidLoad() {
            super.viewDidLoad()
            
        
        // set default text
            topText.text = "TOP"
            bottomText.text = "BOTTOM"
            
            // set default attributes and alignment
        
            topText.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            
            bottomText.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            
            topText.defaultTextAttributes = memeTextAttributes
            
            bottomText.defaultTextAttributes = memeTextAttributes
        
            topText.delegate = self
        
            bottomText.delegate = self
            
        

        }
        
        override func viewWillAppear(animated: Bool) {
            
            super.viewWillAppear(animated)
            
            //hide camera if disabled
            
            cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            
            //subscribe to keyboard notifications
            
            self.subscribeToKeyboardNotifications()
            
        }
        
        override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            
            //unsubscribe to keyboard notifications
            
            self.unsubscribeFromKeyboardNotifications()
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        

        func textFieldShouldReturn(textField: UITextField) -> Bool
        {
            textField.resignFirstResponder()
            
            return true
        }
        
        func subscribeToKeyboardNotifications() {
            //defines keyboard notifications subscription
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
        }
        
        func unsubscribeFromKeyboardNotifications() {
            
            //defines keyboard notification for unsubscribe
            
            NSNotificationCenter.defaultCenter().removeObserver(self, name:
                UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name:
                UIKeyboardWillHideNotification, object: nil)
        }

        func keyboardWillShow(notification: NSNotification) {
            //shift keyboard up for bottom text 
            
            if bottomText.isFirstResponder() {
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
        func keyboardWillHide(notification: NSNotification) {
            //shift keyboard down after finishing writing bottom text
            
            if bottomText.resignFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(notification)
            }
        }
        func getKeyboardHeight(notification: NSNotification) -> CGFloat {
            
            //get the keyboard height
            
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.CGRectValue().height
        }

        
        
        @IBAction func pickButton(sender: AnyObject) {
            
            //launch photo picker 
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(pickerController, animated: true, completion: nil)
            
            
        }
        
        func textFieldDidBeginEditing(textField: UITextField) {
            //clears default text when editing begins
            
            if textField.text == "TOP"{
                textField.text = " "
            }
            if textField.text == "BOTTOM"{
                    textField.text = " "
                }
            }
        
        
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageView.image = image
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            beginLabel.text = ""
            
        }
        
        
        
        @IBAction func cameraButton(sender: AnyObject) {
            //get photo from camera
    
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(pickerController, animated: true, completion: nil)
        }
        
        
        struct Meme {
            //define meme structure
            var topTextField: String?
            var bottomTextField: String?
            var image: UIImage?
            var MemedImage: UIImage?
            
        }
        func memeImage() -> UIImage {
             // sets meme as an image
            toolBar.hidden = true
        
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.drawViewHierarchyInRect(self.view.frame,
                afterScreenUpdates: true)
            let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            toolBar.hidden = false
            
            return memedImage
            
        }
        
        func save(_: Meme) {
            
            //saves the meme
            
            var meme = Meme(
                topTextField:topText.text!,
                bottomTextField:bottomText.text!,
                image:imageView.image!,
                MemedImage: memeImage()
                
            )
            

            
        }
        
        
        @IBAction func shareMeme(sender: AnyObject) {
            
            //launch acitivity view controller to shar meme
            
            let image =  UIImage()
            topText.resignFirstResponder()
            bottomText.resignFirstResponder()
            let newMemedImage = memeImage()
            
            let newmeme = Meme(topTextField: topText.text, bottomTextField: bottomText.text, image: imageView.image, MemedImage: newMemedImage)
            
            let avc = UIActivityViewController(activityItems: [newMemedImage], applicationActivities: nil)
            self.presentViewController(avc, animated: true, completion: nil)
            avc.completionWithItemsHandler = { activity, success, items, error in
                if success {
                    self.save(newmeme)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                
            }
            
            
        }
        
    }
