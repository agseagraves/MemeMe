//
//  ViewController.swift
//  MemeMe
//
//  Created by Anita Seagraves on 5/4/15.
//  Copyright (c) 2015 Anita Seagraves. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomMessage: UITextField!
    @IBOutlet weak var topMessage: UITextField!
    
    @IBOutlet weak var shareButton: UIButton!
    
    var memedImage = UIImage()
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // disable the camara button if not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // disable the share button if no image
        if imagePickerView.image != nil {
            shareButton.enabled = true
        } else {
            shareButton.enabled = false
        }

        self.subscribeToKeyboardNotifications()
        
    }
    
    // Unsubscribe from notifications
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topMessage.delegate = self
        self.bottomMessage.delegate =  self
        
        self.bottomMessage.text = "BOTTOM"
        self.topMessage.text = "TOP"
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        self.bottomMessage.defaultTextAttributes = memeTextAttributes
        self.topMessage.defaultTextAttributes = memeTextAttributes
        
        self.topMessage.textAlignment = NSTextAlignment.Center
        self.bottomMessage.textAlignment = NSTextAlignment.Center
        
        self.topMessage.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.bottomMessage.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        self.imagePickerView.image = nil
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        // Blank out existing text
        textField.text = ""
    }

    func textFieldDidEndEditing(textField: UITextField) {
        // Don't leave text empty, reset to default
        if self.bottomMessage.text == "" {
            self.bottomMessage.text = "BOTTOM"
        }
        if self.topMessage.text == "" {
            self.topMessage.text = "TOP"
        }
    }

    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }

    // Handle keyboard subscriptions
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomMessage.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomMessage.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func save() {
        //Create the meme
        var meme = Meme(top:self.topMessage.text, bottom:self.bottomMessage.text, image:self.imagePickerView.image!, memedImage:self.memedImage)
        
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)

        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        return memedImage
    }
    
    func callTabNavigation() {
        var controller:UITabBarController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("tabController") as! UITabBarController
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func share(sender: AnyObject) {
        // Set up and present the Activity View Controller
        self.memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(
            activityItems: [self.memedImage],
            applicationActivities: nil)
        
        self.navigationController!.presentViewController(activityViewController,
            animated: true,
            completion: nil)
        
        // set up a completion handler
        activityViewController.completionWithItemsHandler = {
            (activityType, completed:Bool, returnedItems, error:NSError!) in
            
            if !completed {
                println("cancelled")
                return
            }
            // Save the Meme
            self.save()
            
            // Dismiss activity view
            activityViewController.dismissViewControllerAnimated(true, completion: nil)
            
            // return to the saved memes
            self.callTabNavigation()
        }
        
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

