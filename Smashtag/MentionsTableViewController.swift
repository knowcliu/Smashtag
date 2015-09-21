//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Caroline Liu on 2015-09-07.
//  Copyright (c) 2015 Caroline Liu. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

    var tweet: Tweet!
    
    enum mentionsSections: CustomStringConvertible {
        case Hashtags
        case Users
        case Media
        case URLS
        
        var description: String {
            switch self {
            case .Hashtags:
                return "Hashtags"
            case .URLS:
                return "URLs"
            case .Users:
                return "Users"
            case .Media:
                return "Images"
            }
        }
    }
    
    var groups = [mentionsSections]()
    
    var selectedText: String?
    
    func loadSections() {
        if (groups.count == 0) {
            if (tweet.media.count > 0) {
                groups.append(mentionsSections.Media)
            }
            if (tweet.hashtags.count > 0) {
                groups.append(mentionsSections.Hashtags)
            }
            if (tweet.userMentions.count > 0) {
                groups.append(mentionsSections.Users)
            }
            if (tweet.urls.count > 0) {
                groups.append(mentionsSections.URLS)
            }
        }
    }
    
    private func fetchImage(imageURL: NSURL, cell: ImageTableViewCell) {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            let imageData = NSData(contentsOfURL: imageURL)
            dispatch_async(dispatch_get_main_queue()) {
                if imageData != nil {
                    cell.imageView?.image = UIImage(data: imageData!, scale: 1)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSections()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return groups.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch groups[section] {
        case .Hashtags:
            return tweet.hashtags.count ?? 0
        case .Media:
            return tweet.media.count ?? 0
        case .URLS:
            return tweet.urls.count ?? 0
        case .Users:
            return tweet.userMentions.count ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        switch groups[indexPath.section] {
        case .Media:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellReuseIdentifier, forIndexPath: indexPath) as! ImageTableViewCell
            if cell.imageView?.image == nil {
                fetchImage(tweet.media[indexPath.row].url, cell: cell)
            }
            return cell
        case .Users:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellReuseIdentifier, forIndexPath: indexPath) 
            cell.textLabel?.text = tweet.userMentions[indexPath.row].keyword
            return cell
        case .Hashtags:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellReuseIdentifier, forIndexPath: indexPath) 
            cell.textLabel?.text = tweet.hashtags[indexPath.row].keyword
            return cell
        case .URLS:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellReuseIdentifier, forIndexPath: indexPath) 
            cell.textLabel?.text = tweet.urls[indexPath.row].keyword
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return groups[section].description
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch groups[indexPath.section] {
        case .URLS:
            if let URL = NSURL(string: tweet.urls[indexPath.row].keyword) {
                UIApplication.sharedApplication().openURL(URL)
            }
        case .Hashtags:
            self.selectedText = tweet.hashtags[indexPath.row].keyword
            self.performSegueWithIdentifier(Storyboard.UnwindReuseIdentifier, sender: self)
        case .Users:
            self.selectedText = tweet.userMentions[indexPath.row].keyword
            self.performSegueWithIdentifier(Storyboard.UnwindReuseIdentifier, sender: self)
        case .Media:
            // TODO: segue to new view which will allow gestures on the image
            break
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Configure the cell...
        switch groups[indexPath.section] {
        case .Media:
            let aspectRatio = tweet.media[indexPath.row].aspectRatio
            return view.frame.width / CGFloat(aspectRatio)

        case .Hashtags, .URLS, .Users:
            return UITableViewAutomaticDimension
        }
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

}
