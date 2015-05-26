//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Anita Seagraves on 5/7/15.
//  Copyright (c) 2015 Anita Seagraves. All rights reserved.
//


import UIKit

class MemeTableViewController : UITableViewController {
    
    let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    func showEditor() {
        var controller:UINavigationController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("editorController") as! UINavigationController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func addButton(sender: AnyObject) {
        showEditor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // show editor if no memes
        //if appDelegate.memes.count == 0 {
        //    showEditor()
        //}
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellID = "TableMemeCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID, forIndexPath: indexPath) as! UITableViewCell
        
        let meme = appDelegate.memes[indexPath.row]

        cell.textLabel!.text = meme.top + " " + meme.bottom
        cell.imageView?.image = meme.memedImage
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController

        self.navigationController!.pushViewController(detailController, animated: true)
        
        detailController.meme = appDelegate.memes[indexPath.row]
        detailController.imageView?.image = appDelegate.memes[indexPath.row].image
        detailController.memeIndex = indexPath.row
    }

    
}

