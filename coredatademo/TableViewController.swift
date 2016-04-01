//
//  TableViewController.swift
//  coredatademo
//
//  Created by alex berkson on 12/9/15.
//  Copyright © 2015 alex berkson. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UITableViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var people = [NSManagedObject]()
    
    @IBAction func addpressed(sender: AnyObject) {
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.saveName(textField!.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
     
        //2
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        //3
        do {
            let results =
            try self.managedObjectContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveName(name: String) {
        
        //2
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:managedObjectContext)
        
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        do {
            try managedObjectContext.save()
            //5
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deletespecificname(name: String) {
        

        let predicate = NSPredicate(format: "name == %@", name)
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        fetchRequest.predicate = predicate
        var deletedpeople = [NSManagedObject]()
        
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest)
            deletedpeople = results as! [NSManagedObject]
            
            for person in deletedpeople {
                managedObjectContext.deleteObject(person)
            }

        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            
        }
    }
   
    func deleteent(index: Int) {
        
        let fetchRequest = NSFetchRequest(entityName: "Person")

        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
            managedObjectContext.deleteObject(people[index])
            people.removeAtIndex(index)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        do {
            _ = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch {
            // Do something in response to error condition
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            // Do something in response to error condition
        }
        
    }
    
    
    @IBAction func searchpressed(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Delete Name",
            message: "who would you like to delete",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.deletespecificname(textField!.text!)
                
                //2
                let fetchRequest = NSFetchRequest(entityName: "Person")
                
                //3
                do {
                    let results =
                    try self.managedObjectContext.executeFetchRequest(fetchRequest)
                    self.people = results as! [NSManagedObject]
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
                
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    func updateentity(index: Int, name: String) {
        
        // Assuming type has a reference to managed object context
        
        // Assuming that a specific NSManagedObject's objectID property is accessible
        // Alternatively, could supply a predicate expression that's precise enough
        // to select only a _single_ entity

        //let predicate = NSPredicate(format: "name == %@", managedContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Person")
        //fetchRequest.predicate = predicate
        
        do {
            let results =
            try self.managedObjectContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        print(people.count)
        
        let person = people[index]
        person.setValue(name, forKey: "name")

        do {
            try self.managedObjectContext.save()
        } catch {
            print("error!")
            // Do something in response to error condition
        }
    }
    
    
    func insertnewentity () {
    // Assuming encapsulating Type has a reference to managed object context
    // Set properties
    
        
    do {
    try managedObjectContext.save()
    } catch {
    // Do something in response to error condition
    }
    }
  
    func fetchallentities() {

    let fetchRequest = NSFetchRequest(entityName: "Person")
        fetchRequest.fetchLimit = 10
    do {
    let fetchedEntities = try managedObjectContext.executeFetchRequest(fetchRequest) as! [String]
    // Do something with fetchedEntities
        print(fetchedEntities)
    } catch {
        print("cant fetch")
        
    // Do something in response to error condition
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "\"Core Data\""

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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let person = people[indexPath.row]

        cell.textLabel?.text =
            person.valueForKey("name") as? String
        cell.detailTextLabel?.text = person.valueForKey("birthdate") as? String
        print(person.valueForKey("birthdate") as? String)
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "Change Name",
            message: "change the name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                //self.saveBirthdate((textField!.text!))
                self.updateentity(indexPath.row, name: textField!.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            deleteent(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
