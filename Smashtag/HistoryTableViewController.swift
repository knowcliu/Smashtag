//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by Caroline Liu on 2015-09-19.
//  Copyright (c) 2015 Caroline Liu. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    var selectedText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Clicking on another tab or another area of the scene does not appear to call viewDidLoad.
        // In these cases, make sure the data is reloaded before presenting the table.
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return SearchHistory.sharedHistory.last100Searches.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.SearchTermReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        // display the most recent searches first
        let searchTerm = SearchHistory.sharedHistory.last100Searches.reverse()[indexPath.row]
        cell.textLabel!.text = searchTerm
        return cell
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.selectedText = SearchHistory.sharedHistory.last100Searches.reverse()[indexPath.row]
        return indexPath
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

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
        if let ttvc = segue.destinationViewController as? TweetTableViewController {
            if let identifier = segue.identifier {
                if identifier == Storyboard.TweetSearchReuseIdentifier {
                    if let searchTerm = self.selectedText {
                        ttvc.searchText = searchTerm
                    }
                }
            }
        }
    }

}
