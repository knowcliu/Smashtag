//
//  Tweet TableViewCell.swift
//  Smashtag
//
//  Created by Caroline Liu on 2015-09-04.
//  Copyright (c) 2015 Caroline Liu. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    func updateUI() {
        // reset any existing tweet information
        tweetProfileImageView?.image = nil
        tweetScreenNameLabel?.text = nil
        tweetTextLabel?.text = nil
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            
            if (tweetTextLabel.text != nil) {
                for _ in tweet.media {
                    tweetTextLabel.text! +=  " 📷"
                }
                
                let attrTweet = NSMutableAttributedString(string: tweetTextLabel.text!)
                for hashtag in tweet.hashtags {
                    attrTweet.setAttributes([NSForegroundColorAttributeName: UIColor.purpleColor()], range: hashtag.nsrange)
                }

                for url in tweet.urls {
                    attrTweet.setAttributes([NSForegroundColorAttributeName: UIColor.blueColor()], range: url.nsrange)
                }
                
                for mention in tweet.userMentions {
                    attrTweet.setAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], range: mention.nsrange)
                }
                
                tweetTextLabel.attributedText = attrTweet
                tweetTextLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            }
                        
            tweetScreenNameLabel?.text = "\(tweet.user)"
            tweetScreenNameLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            
            if let profileImageURL = tweet.user.profileImageURL{
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}
