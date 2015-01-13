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
    var sortBy:String = "createdAt"
    
    @IBOutlet weak var sorter: UISegmentedControl!
    @IBAction func sorter(sender: UISegmentedControl) {
        
        switch sorter.selectedSegmentIndex
        {
        case 0:
            sortBy = "createdAt";
            sortData()
        case 1:
            sortBy = "accomplished";
            sortData()
            
            
        default:
            break; 
        }
        
        
    }
    func sortData() {
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: sortBy, ascending: false)
        var sortedResults: NSArray = dataParse.sortedArrayUsingDescriptors([descriptor])
        
        var mutableArr = NSMutableArray(array: sortedResults)
        dataParse = mutableArr
        self.tableView.reloadData()
    }

    
    func loadData() {
        
        var query = PFQuery(className:"SomethingNew")
        query.whereKey("show", equalTo: 1)
        query.orderByDescending(self.sortBy)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) spots.")
                // Do something with the found objects
                for object in objects {
                    NSLog("%@", object.objectId)
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
        
        cell.textLabel!.text = cellDataParse.objectForKey("learned") as? String
        var accomplished = cellDataParse.objectForKey("accomplished") as? Float
        var a = "a"
        if (accomplished >= 8 && accomplished < 10) {
                a = "\u{1F60A}"
            }
            else if (accomplished >= 6 && accomplished < 8) {
                a = "\u{1F603}"
            }
            else if (accomplished >= 4 && accomplished < 6) {
                a = "\u{1F610}"
            }
            else if (accomplished >= 2 && accomplished < 4) {
                a = "\u{1F60F}"
            }
            else if (accomplished < 2 && accomplished > 0) {
                a = "\u{1f61E}"
            }
            else if (accomplished == 10) {
                a = "\u{1f60B}"
            }
            else {
                a = "\u{1f616}"
            }

        
        cell.detailTextLabel!.text = a
        return cell
        
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var deleteButton = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(
                self.tableView,
                commitEditingStyle: .Delete,
                forRowAtIndexPath: indexPath
            )
            
            return
        })
        
        deleteButton.backgroundColor = UIColor.blackColor()
        deleteButton.title = "Forget"
        
        return [deleteButton]
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let selectedId = self.dataParse[indexPath.row].objectId
            //println(self.dataParse[indexPath.row])
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let viewController = segue.destinationViewController as DetailViewController
        let indexPath = self.tableView.indexPathForSelectedRow()!
        let object = self.dataParse.objectAtIndex(indexPath.row) as PFObject
        viewController.object = object
        
    }
    

}
