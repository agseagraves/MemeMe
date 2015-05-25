//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Anita Seagraves on 5/7/15.
//  Copyright (c) 2015 Anita Seagraves. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {


    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    var memeIndex: Int = 0
    
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)


        self.imageView!.image = self.meme.memedImage
        
        self.tabBarController?.tabBar.hidden = true

    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        appDelegate.memes.removeAtIndex(memeIndex)
        
        self.navigationController?.popViewControllerAnimated(true)
        
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

    }
}