//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit
import ActiveLabel

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var isFavorite = false
    
    
    var hasTweetTextView = false
    
    var tweet: Tweet! {
        didSet {
            
            if let text = tweet.text {
                if let url = tweet.url {
                    if let displayUrl = tweet.displayUrl {
                        tweetTextLabel.text = text.replacingCharacters(in: text.range(of: url)!, with: displayUrl)
                        
                        let urlType = ActiveType.custom(pattern: tweet.displayUrl!)
                        tweetTextLabel.enabledTypes.append(urlType)
                        
                        tweetTextLabel.customColor[urlType] = UIColor(red: 66/255, green: 173.0/255, blue: 244/255, alpha: 1)
                        
                        tweetTextLabel.customSelectedColor[urlType] = UIColor(red: 66/255, green: 140.0/255, blue: 244/255, alpha: 1)
                        
                        tweetTextLabel.handleCustomTap(for: urlType, handler: {
                            (urlString) in
                            print(urlString)
                        })
                    }
                } else {
                    tweetTextLabel.text = tweet.text
                }
            }
            
            
            
            
            
            nameLabel.text = tweet.name
            
            if tweet.favorited! {
                print("Favorited already")
                favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
            }
            
            
            if let screenName = tweet.screenName {
                screenNameLabel.text = "@\(screenName)"
            }
            
            if let profileUrl = tweet.profileImageUrl {
                profileImageView.setImageWith(profileUrl)
            }
            
            // tweetTextLabel.text = tweet.text
            
            print(tweet.text!)
            
            tweetTextLabel.customize { label in
                
                
                
                label.hashtagColor = UIColor(red: 66/255, green: 173.0/255, blue: 244/255, alpha: 1)
                label.mentionColor = UIColor(red: 66/255, green: 173.0/255, blue: 244/255, alpha: 1)
                label.URLColor = UIColor(red: 66/255, green: 173.0/255, blue: 244/255, alpha: 1)
                label.URLSelectedColor = UIColor(red: 66/255, green: 140.0/255, blue: 244/255, alpha: 1)
                label.mentionSelectedColor = UIColor(red: 66/255, green: 140.0/255, blue: 244/255, alpha: 1)
                label.hashtagSelectedColor = UIColor(red: 66/255, green: 140.0/255, blue: 244/255, alpha: 1)
                label.handleMentionTap { _ in print("Tapped Mention") }
                label.handleHashtagTap { _ in print("Tapped Hashtag") }
                label.handleURLTap { _ in print("Tapped URL") }
            }
            
            if tweet.retweetCount == 0 {
                retweetCountLabel.isHidden = true
            } else {
                retweetCountLabel.isHidden = false
                retweetCountLabel.text = "\(tweet.retweetCount)"
            }
            
            if tweet.favoritesCount == 0 {
                favoritesCountLabel.isHidden = true
            } else {
                favoritesCountLabel.isHidden = false
                favoritesCountLabel.text = "\(tweet.favoritesCount)"
            }
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Rounded corner profile image view
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onReplyButton(_ sender: Any) {
        print("Reply button tapped")
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        print("Retweet button tapped")
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        
        print("Favorite button tapped")
        
        if isFavorite {
            print("To disfavor")
            isFavorite = false
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        } else {
            print("To favor")
            isFavorite = true
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        }
        
        
    }
    
    @IBAction func onMessageButton(_ sender: Any) {
        print("Message button tapped")
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
