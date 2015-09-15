//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Caroline Liu on 2015-09-07.
//  Copyright (c) 2015 Caroline Liu. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

    var tweet: Tweet?
    
    enum mentionsSections: Printable {
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
    
    // the list of text to display per mention type
    var sections = [(mentionsSections, [String])]()
    
    var selectedText : String?
    
    func loadSections() {
        if (sections.count == 0) {
            if (tweet?.media.count > 0) {
                sections.append(
                    (mentionsSections.Media, tweet!.media.map( {"\($0.url)" } ) ) )
            }
            if (tweet?.hashtags.count > 0) {
                sections.append(
                    (mentionsSections.Hashtags, tweet!.hashtags.map( {"\($0.keyword)"} ) ) )
            }
            if (tweet?.userMentions.count > 0) {
                sections.append(
                    (mentionsSections.Users, tweet!.userMentions.map( {"\($0.keyword)" } ) ) )
            }
            if (tweet?.urls.count > 0) {
                sections.append(
                    (mentionsSections.URLS, tweet!.urls.map({"\($0.keyword)"} ) ) )
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
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return sections[section].1.count
    }
    
    
    private struct Storyboard {
        static let TextCellReuseIdentifier = "TextCell"
        static let ImageCellReuseIdentifier = "ImageCell"
        static let UnwindReuseIdentifier = "UnwindToTweetTable"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        var (sectionType, rows) = sections[indexPath.section]
        switch sectionType {
        case .Media:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            if let url = NSURL(string: rows[indexPath.row]) {
                if let data = NSData(contentsOfURL: url) {
                    cell.contentMode = UIViewContentMode.ScaleAspectFit
                    cell.imageView?.image = UIImage(data: data)
                    // cell.imageView?.sizeThatFits(size: )
                }
            }
            return cell
        case .Hashtags, .Users, .URLS:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = rows[indexPath.row]
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return sections[section].0.description
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var (sectionType, rows) = sections[indexPath.section]
        switch sectionType {
        case .URLS:
            if let URL = NSURL(string: rows[indexPath.row]) {
                UIApplication.sharedApplication().openURL(URL)
            }
        case .Hashtags, .Users:
            self.selectedText = rows[indexPath.row]
            self.performSegueWithIdentifier(Storyboard.UnwindReuseIdentifier, sender: self)
        case .Media:
            break
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
