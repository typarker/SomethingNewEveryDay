//
//  TableViewController.swift
//  SomethingNewEveryDay
//
//  Created by Ty Parker on 12/5/14.
//  Copyright (c) 2014 Ty Parker. All rights reserved.
//

import UIKit

class WhatsBeenDoneTableViewController: UITableViewController {
    
    
    var dataParse:NSMutableArray = NSMutableArray()
    
    
    
    func loadData() {
        
        var query = PFQuery(className:"SomethingNew")
        query.whereKey("show", equalTo: 1)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) spots.")
                // Do something with the found objects
                for object in objects {
                    NSLog("%@", object.objectId)
                    //let latitude = object["latitude"] as Double
                    self.dataParse.addObject(object)
                }
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
            self.tableView.reloadData()
        }

    }
   


    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //loadData()
        return self.dataParse.count
        
     
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("numberCell") as UITableViewCell
        
        let cellDataParse:PFObject = self.dataParse.objectAtIndex(indexPath.row) as PFObject
        
        cell.textLabel.text = cellDataParse.objectForKey("learned") as? String
        return cell
        
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let selectedId = self.dataParse[indexPath.row].objectId
            var query = PFQuery(className:"SomethingNew")
            query.getObjectInBackgroundWithId(selectedId) {
                (somethingNew: PFObject!, error: NSError!) -> Void in
                if error != nil {
                    NSLog("%@", error)
                }
                else {
                    somethingNew.incrementKey("show", byAmount: -1)
                    somethingNew.saveInBackground()
                }
            }

            
            dataParse.removeObjectAtIndex(indexPath.row) //removes from local array
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic) //deletes row
            
        }
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
