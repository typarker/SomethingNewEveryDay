//
//  WhatsBeenDoneTableViewController.swift
//  SomethingNewEveryDay
//
//  Created by Ty Parker on 12/4/14.
//  Copyright (c) 2014 Ty Parker. All rights reserved.
//

    import UIKit
    import CoreData
    
    class WhatsBeenoneTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
        
        var managedObjectContext: NSManagedObjectContext? = nil
        var dataParse:NSMutableArray = NSMutableArray()
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        func loadData(){
            
            var query = PFQuery(className:"SomethingNew")
            //query.whereKey("spots", greaterThan: 0)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    NSLog("Successfully retrieved \(objects.count) spots.")
                    // Do something with the found objects
                    for object in objects {
                        NSLog("%@", object.objectId)
                        //let latitude = object["latitude"] as Double
                        self.dataParse.addObject(object)                    }
                } else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
            }
            
            //println(lots)
            // Create annotations for each one
            /*for lot in lotWithSpot {
            let aLot = lot as Lot
            let coord = CLLocationCoordinate2D(latitude: aLot.latitude, longitude: aLot.longitude);
            let lotAnnotation = LotAnnotation(coordinate: coord, title: String(aLot.price), subtitle: "Dollars", lot: aLot, id: aLot.id) // 3
            mapView.addAnnotation(lotAnnotation) // 4
            
            }
            
            println(lotWithSpot)
            */
        }

        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            //self.navigationItem.leftBarButtonItem = self.editButtonItem()
            loadData()
            
            //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
            //self.navigationItem.rightBarButtonItem = addButton
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func insertNewObject(sender: AnyObject) {
            let context = self.fetchedResultsController.managedObjectContext
            let entity = self.fetchedResultsController.fetchRequest.entity!
            let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as NSManagedObject
            
            // If appropriate, configure the new managed object.
            // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
            newManagedObject.setValue(NSDate(), forKey: "timeStamp")
            
            // Save the context.
            var error: NSError? = nil
            if !context.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
        
        // MARK: - Segues
        
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "showDetail" {
                if let indexPath = self.tableView.indexPathForSelectedRow() {
                    let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
                    (segue.destinationViewController as DetailViewController).detailItem = object
                }
            }
        }
        
        // MARK: - Table View
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.dataParse.count
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
           
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            
            let cellDataParse:PFObject = self.dataParse.objectAtIndex(indexPath.row) as PFObject
            
            //let cell.textLabel = cellDataParse.objectForKey("learned") as String
            return cell
            
            
        }
        
        override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        
        override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
                let context = self.fetchedResultsController.managedObjectContext
                context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
                
                var error: NSError? = nil
                if !context.save(&error) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    //println("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
            }
        }
        
        func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
            let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
            cell.textLabel.text = object.valueForKey("timeStamp")!.description
        }
        
        // MARK: - Fetched results controller
        
        var fetchedResultsController: NSFetchedResultsController {
            if _fetchedResultsController != nil {
                return _fetchedResultsController!
            }
            
            let fetchRequest = NSFetchRequest()
            // Edit the entity name as appropriate.
            let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
            fetchRequest.entity = entity
            
            // Set the batch size to a suitable number.
            fetchRequest.fetchBatchSize = 20
            
            // Edit the sort key as appropriate.
            let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
            let sortDescriptors = [sortDescriptor]
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            // Edit the section name key path and cache name if appropriate.
            // nil for section name key path means "no sections".
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
            aFetchedResultsController.delegate = self
            _fetchedResultsController = aFetchedResultsController
            
            var error: NSError? = nil
            if !_fetchedResultsController!.performFetch(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
            
            return _fetchedResultsController!
        }
        var _fetchedResultsController: NSFetchedResultsController? = nil
        
        func controllerWillChangeContent(controller: NSFetchedResultsController) {
            self.tableView.beginUpdates()
        }
        
        func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
            switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
            }
        }
        
        func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            default:
                return
            }
        }
        
        func controllerDidChangeContent(controller: NSFetchedResultsController) {
            self.tableView.endUpdates()
        }
        
        /*
        // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
        
        func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // In the simplest, most efficient, case, reload the table view.
        self.tableView.reloadData()
        }
        */
        
}
