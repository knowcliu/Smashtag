//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Caroline Liu on 2015-09-04.
//  Copyright (c) 2015 Caroline Liu. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    var tweets = [[Tweet]]()
    
    var searchText: String? = "#stanford" {
        didSet {
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            // add the search to NSUserData to store the top 100 searches
            if searchText != nil {
                SearchHistory.sharedHistory.addSearchTerm(searchText!)
            }
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    /*
    DEMO: handling the NSNotification for Accessibility Fonts
    Maybe you want the UI to change if the font is too big and the buttons will overflow. This isn't needed if you let the text fields use the TextStyles and not the System or Custom styles: (eg use Body, Headline, Subhead etc instead of "System 17")
    
    let center = NSNotificationCenter.defaultCenter()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        center.addObserverForName(UIContentSizeCategoryDidChangeNotification,
            object: UIApplication.sharedApplication(),
            queue: NSOperationQueue.mainQueue()) {
    notification in
    let c = notification.userInfo?[UIContentSizeCategoryNewValueKey]
        }
    }

    override func viewDidDisappear(animated: Bool) {
        center.removeObserver(UIContentSizeCategoryDidChangeNotification)
    }
*/
    
    var lastSuccessfulRequest: TwitterRequest?
    var nextRequestAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        // Load our model...
        if (searchText != nil) {
            if let request = nextRequestAttempt {
                request.fetchTweets { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if (newTweets.count > 0) {
                            self.lastSuccessfulRequest = request
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                        }
                        sender?.endRefreshing()
                    }
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == searchTextField) {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    @IBAction func unwindFromMentionsTableViewController(sender: UIStoryboardSegue) {
        if sender.identifier == Storyboard.UnwindReuseIdentifier {
            if let mtvc = sender.sourceViewController as? MentionsTableViewController {
                searchText = mtvc.selectedText
            }
        }
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return tweets[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell

        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mtvc = segue.destinationViewController as? MentionsTableViewController {
            if let identifier = segue.identifier {
                if let tweetCell = sender as? TweetTableViewCell {
                    if (identifier == Storyboard.MentionsReuseIdentifier) {
                        mtvc.tweet = tweetCell.tweet
                    }
                }
            }
        }
    }
}
