# Smashtag
A Twitter client. Project 4 for Stanford CS193p iOS course.

## How to enable Dynamic Type 
Dynamic Type is the thing that enables the user to be in control of how large or small they want their font sizes. It is confiured in *Settings > General > Accessibility > Large Text*
- For all text Labels, Buttons and Text in the storyboard, ensure the Font style is set to *Text Styles* rather than *System* styles
eg: *Body* instead of *System 16.0*
- For any text that is set programmatically, you can update the font property like so:

```
tweetTextLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
```
- If you really don't like what happens when the font gets jumbo-sized, you can do other things with your UI by observing the `UIContentSizeCategoryDidChangeNotification` notification.

```
    let center = NSNotificationCenter.defaultCenter()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        center.addObserverForName(UIContentSizeCategoryDidChangeNotification,
            object: UIApplication.sharedApplication(),
            queue: NSOperationQueue.mainQueue()) { notification in
              let c = notification.userInfo?[UIContentSizeCategoryNewValueKey]
        }
    }

    override func viewDidDisappear(animated: Bool) {
        center.removeObserver(UIContentSizeCategoryDidChangeNotification)
    }
```
