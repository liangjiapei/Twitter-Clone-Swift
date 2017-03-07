//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Jiapei Liang on 3/6/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var composeToolbar: UIToolbar!
    @IBOutlet weak var countdownLabel: UIBarButtonItem!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetTextview: UITextView!
    
    var tweetId: Int!
    var screenName: String!
    
    var tweetsViewController: TweetsViewController!
    
    var tweetCharactersCountdown = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("Current user profile image url: \(User.currentUser?.profileUrl)")
        avatarImageView.setImageWith((User.currentUser?.profileUrl)!)
        
        tweetTextview.delegate = self
        
        if let screenName = screenName {
            tweetTextview.text = "@\(screenName)"
        }
        
        composeButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDismissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.toolbarBottomConstraint.constant = keyboardSize.height
            print("Keyboard will show keyboard size: \(keyboardSize.height)")
            
        }
        
    }
    
    func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.toolbarBottomConstraint.constant = 0
            print("Keyboard will hide keyboard size: \(keyboardSize.height)")
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        tweetCharactersCountdown = 140 - textView.text.characters.count
        
        if (tweetCharactersCountdown == 140) {
            composeButton.isEnabled = false
        } else {
            composeButton.isEnabled = true
        }
        
        countdownLabel.title = "\(tweetCharactersCountdown)"
    }
    
    
    @IBAction func onTweetButton(_ sender: Any) {
        
        TwitterClient.sharedInstance?.reply(status: tweetTextview.text, replyId: self.tweetId, success: { (tweet: NSDictionary) in
            
            if let tweet = tweet as? NSDictionary {
                
                self.tweetsViewController.tweets.insert(Tweet.init(dictionary: tweet), at: 0)
                
                self.tweetsViewController.tableView.reloadData()
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
