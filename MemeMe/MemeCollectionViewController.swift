//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Anita Seagraves on 5/6/15.
//  Copyright (c) 2015 Anita Seagraves. All rights reserved.
//
import UIKit

class MemeCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var meme: Meme!
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    func showEditor() {
        var controller:UINavigationController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("editorController") as! UINavigationController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
        
    @IBAction func editorButton(sender: AnyObject) {
        showEditor()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        self.collectionView?.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "MemeCell")

    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // show editor if no memes
        //if appDelegate.memes.count == 0 {
        //    showEditor()
        //}

    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! UICollectionViewCell

        let meme = appDelegate.memes[indexPath.item]
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController

        
        self.navigationController!.pushViewController(detailController, animated: true)
        
        detailController.meme = appDelegate.memes[indexPath.row]
        detailController.imageView?.image = appDelegate.memes[indexPath.row].image
        detailController.memeIndex = indexPath.row
    }
}
