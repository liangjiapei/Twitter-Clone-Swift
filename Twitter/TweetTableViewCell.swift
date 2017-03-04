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
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var leftImageStackView: UIStackView!
    @IBOutlet weak var rightImageStackView: UIStackView!
    
    @IBOutlet weak var leftImageStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageStackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageStackHeightConstraint: NSLayoutConstraint!
    var isFavorite = false
    var isRetweeted = false
    
    var vc: TweetsViewController!
    
    var hasTweetTextView = false
    
    var tweet: Tweet! {
        didSet {
            
            updateUI()
            print("Did set tweet")
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Rounded corner profile image view
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        leftImageStackView.distribution = .fill
        rightImageStackView.distribution = .fill
        imageStackView.distribution = .fill
        
        imageStackHeightConstraint.constant = imageStackView.frame.width * 0.6
        
        self.layoutIfNeeded()
        
        print("awakeFromNib")
    
    }
    
    
    
    func onTapImageView(sender : UITapGestureRecognizer) {
        print("Tap image")
    
        let imageView = sender.view as! UIImageView
        
        vc.selectedImage = imageView.image
        
        vc.performSegue(withIdentifier: "showImageInFullScreenSegue", sender: vc)
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
        if isRetweeted {
            print("To unretweet")
            
            if let id = tweet.id {
                
                TwitterClient.sharedInstance?.unretweet(id: id, success: { (tweet) in
                    
                    self.handleUnretweet();
                    
                }, failure: { (error: Error) in
                    
                    print("Failed to retweet")
                    print("error: \(error.localizedDescription)")
                    
                })
            }
        } else {
            print("To retweet")
            
            if let id = tweet.id {
                
                TwitterClient.sharedInstance?.retweet(id: id, success: { (tweet) in
                    
                    self.handleRetweet();
                    
                }, failure: { (error: Error) in
                    
                    print("Failed to retweet")
                    print("error: \(error.localizedDescription)")
                    
                })
            }
        }
    }
    
    
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        
        print("Favorite button tapped")
        
        if isFavorite {
            print("To unfavor")
            
            if let id = tweet.id {
                TwitterClient.sharedInstance?.unfavorite(id: id, success: { (tweet) in
                    
                    self.handleUnfavorite();
                    
                }, failure: { (error: Error) in
                    
                    print("Failed to favorite")
                    print("error: \(error.localizedDescription)")
                    
                })
            }
            
        } else {
            print("To favor")
            
            if let id = tweet.id {
                 TwitterClient.sharedInstance?.favorite(id: id, success: { (tweet) in
                    
                    self.handleFavorite();
                  
                 }, failure: { (error: Error) in
                    
                    print("Failed to favorite")
                    print("error: \(error.localizedDescription)")
                    
                })
            }
            
            
            
        }
        
        
    }
    
    
    
    @IBAction func onMessageButton(_ sender: Any) {
        print("Message button tapped")
    }
    
    
    
    func handleFavorite() {
        isFavorite = true
        favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        favoriteCountLabel.textColor = UIColor(red: 0.88, green: 0.23, blue: 0.40, alpha: 1.0)
        
        if let favoriteCountLabelText = favoriteCountLabel.text {
            if !favoriteCountLabelText.isEmpty {
                if let favoriteCount = Int(favoriteCountLabelText) {
                    favoriteCountLabel.text = "\(favoriteCount + 1)"
                }
            } else {
                favoriteCountLabel.text = "1"
            }
        }
    }
    
    
    
    func handleUnfavorite() {
        
        isFavorite = false
        favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        favoriteCountLabel.textColor = UIColor.gray
        
        if let favoriteCountLabelText = favoriteCountLabel.text {
            if !favoriteCountLabelText.isEmpty {
                if let favoriteCount = Int(favoriteCountLabelText) {
                    if favoriteCount - 1 == 0 {
                        favoriteCountLabel.text = ""
                    } else {
                        favoriteCountLabel.text = "\(favoriteCount - 1)"
                    }
                }
            } else {
                // do nothing
            }
        }
        
    }
    
    
    
    func handleRetweet() {
        
        isRetweeted = true
        retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        retweetCountLabel.textColor = UIColor(red: 0.11, green: 0.75, blue: 0.50, alpha: 1.0)
        
        if let retweetCountLabelText = retweetCountLabel.text {
            if !retweetCountLabelText.isEmpty {
                if let retweetCount = Int(retweetCountLabelText) {
                    retweetCountLabel.text = "\(retweetCount + 1)"
                }
            } else {
                retweetCountLabel.text = "1"
            }
        }
        
    }
    
    
    
    func handleUnretweet() {
        isRetweeted = false
        retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        retweetCountLabel.textColor = UIColor.gray
        
        if let retweetCountLabelText = retweetCountLabel.text {
            if !retweetCountLabelText.isEmpty {
                if let retweetCount = Int(retweetCountLabelText) {
                    if retweetCount - 1 == 0 {
                        retweetCountLabel.text = ""
                    } else {
                        retweetCountLabel.text = "\(retweetCount - 1)"
                    }
                }
            } else {
                // do nothing
            }
        }
    }
    
    func updateUI() {
        
        for view in leftImageStackView.subviews {
            view.removeFromSuperview()
        }
        
        
        for view in rightImageStackView.subviews {
            view.removeFromSuperview()
        }
        
        imageStackHeightConstraint.constant = imageStackView.frame.width * 0.6
        
        leftImageStackViewWidthConstraint.constant = imageStackView.frame.width
        rightImageStackViewWidthConstraint.constant = 0
        
        self.layoutIfNeeded()
        
        if tweet.media != nil {
            
            print("has \(tweet.media!.count) photos")
            
            imageStackView.distribution = .fill
            
            if let media1Url = tweet.media1Url {
                
                
                
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImageView))
                
                let imageView1 = UIImageView(image: UIImage(named: "default_image"))
                imageView1.contentMode = .scaleAspectFill
                imageView1.clipsToBounds = true
                imageView1.layer.cornerRadius = 5
                imageView1.isUserInteractionEnabled = true
                imageView1.addGestureRecognizer(tapRecognizer)
                
                imageView1.setImageWith(media1Url)
                
                leftImageStackView.distribution = .fill
                leftImageStackView.addArrangedSubview(imageView1)
                
                leftImageStackViewWidthConstraint.constant = imageStackView.frame.width
                rightImageStackViewWidthConstraint.constant = 0
                
                self.layoutIfNeeded()
                
                print("left image stack view width is \(leftImageStackView.frame.size.width)")
                print("left image stack view height is \(leftImageStackView.frame.size.height)")
                print("right image stack view width is \(rightImageStackView.frame.size.width)")
                
                print("left image width is \(leftImageStackView.subviews[0].frame.width)")
                print("left image height is \(leftImageStackView.subviews[0].frame.height)")
            }
            
            if let media2Url = tweet.media2Url {
                
                print("Has second image")
                
                leftImageStackViewWidthConstraint.constant = imageStackView.frame.width * 0.5
                rightImageStackViewWidthConstraint.constant = imageStackView.frame.width * 0.5
                
                self.layoutIfNeeded()
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImageView))
                
                let imageView2 = UIImageView(image: UIImage(named: "default_image"))
                imageView2.contentMode = .scaleAspectFill
                imageView2.clipsToBounds = true
                imageView2.layer.cornerRadius = 5
                imageView2.isUserInteractionEnabled = true
                imageView2.addGestureRecognizer(tapRecognizer)
                
                imageView2.setImageWith(media2Url)
                rightImageStackView.addArrangedSubview(imageView2)
                
                imageStackView.distribution = .fillEqually
            }
            
            if let media3Url = tweet.media3Url {
                
                print("Has third image")
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImageView))
                
                let imageView3 = UIImageView(image: UIImage(named: "default_image"))
                imageView3.contentMode = .scaleAspectFill
                imageView3.clipsToBounds = true
                imageView3.layer.cornerRadius = 5
                imageView3.isUserInteractionEnabled = true
                imageView3.addGestureRecognizer(tapRecognizer)
                imageView3.setImageWith(media3Url)
                
                if let media4Url = tweet.media4Url {
                    
                    print("Has fourth image")
                    
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImageView))
                    
                    let imageView4 = UIImageView(image: UIImage(named: "default_image"))
                    imageView4.contentMode = .scaleAspectFill
                    imageView4.clipsToBounds = true
                    imageView4.layer.cornerRadius = 5
                    imageView4.isUserInteractionEnabled = true
                    imageView4.addGestureRecognizer(tapRecognizer)
                    imageView4.setImageWith(media4Url)
                    
                    leftImageStackView.addArrangedSubview(imageView3)
                    rightImageStackView.addArrangedSubview(imageView4)
                    
                    
                    
                } else {
                
                    rightImageStackView.addArrangedSubview(imageView3)
                    
                }
                
                imageStackView.distribution = .fillEqually
                leftImageStackView.distribution = .fillEqually
                rightImageStackView.distribution = .fillEqually
                self.layoutIfNeeded()
        
            }
            
            
        } else {
            imageStackHeightConstraint.constant = 0
        }
        
        
        
        /*
         let pikachuImageView2 = UIImageView(image: UIImage(named: "pikachu"))
         pikachuImageView2.contentMode = .scaleAspectFill
         pikachuImageView2.clipsToBounds = true
         
         let pikachuImageView3 = UIImageView(image: UIImage(named: "pikachu"))
         pikachuImageView3.contentMode = .scaleAspectFill
         pikachuImageView3.clipsToBounds = true
         
         let pikachuImageView4 = UIImageView(image: UIImage(named: "pikachu"))
         pikachuImageView4.contentMode = .scaleAspectFill
         pikachuImageView4.clipsToBounds = true
         */
        
        
        
        /*
         leftImageStackView.addArrangedSubview(pikachuImageView4)
         
         rightImageStackView.addArrangedSubview(pikachuImageView2)
         
         rightImageStackView.addArrangedSubview(pikachuImageView3)
         
         self.layoutIfNeeded()
         */
        
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
                        UIApplication.shared.open(URL(string: self.tweet.expandedUrl!)!, options: [:])
                        print(UIApplication.shared.canOpenURL(URL(string: self.tweet.expandedUrl!)!))
                    })
                }
            } else {
                tweetTextLabel.text = tweet.text
            }
        }
        
        
        
        if let dateStr = tweet.created_at {
            let timeDiff = DateStringFormatHelper.getTimeSinceNow(dateStr: dateStr)
            timeLabel.text = "· \(timeDiff)"
        }
        
        nameLabel.text = tweet.name
        
        if tweet.favorited! {
            print("Favorited already")
            isFavorite = true
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
            favoriteCountLabel.textColor = UIColor(red: 0.88, green: 0.23, blue: 0.40, alpha: 1.0)
        } else {
            print("Not Favorited")
            isFavorite = false
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            favoriteCountLabel.textColor = UIColor.gray
        }
        
        if tweet.retweeted! {
            print("Retweeted already")
            isRetweeted = true
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            retweetCountLabel.textColor = UIColor(red: 0.11, green: 0.75, blue: 0.50, alpha: 1.0)
        } else {
            print("Not Retweeted")
            isRetweeted = false
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            retweetCountLabel.textColor = UIColor.gray
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
            label.lineSpacing = 0
            label.urlMaximumLength = 100
            label.hashtagColor = UIColor(red: 66/255, green: 173.0/255, blue: 244/255, alpha: 1)
            label.mentionColor = UIColor(red: 66/255, green: 173.0/255, blue: 244/255, alpha: 1)
            label.URLColor = UIColor(red: 66/255, green: 173.0/255, blue: 244/255, alpha: 1)
            label.URLSelectedColor = UIColor(red: 66/255, green: 140.0/255, blue: 244/255, alpha: 1)
            label.mentionSelectedColor = UIColor(red: 66/255, green: 140.0/255, blue: 244/255, alpha: 1)
            label.hashtagSelectedColor = UIColor(red: 66/255, green: 140.0/255, blue: 244/255, alpha: 1)
            
            /*
             label.handleMentionTap { _ in print("Tapped Mention") }
             label.handleHashtagTap { _ in print("Tapped Hashtag") }
             label.handleURLTap { (url) in
             print("Tapped URL")
             UIApplication.shared.open(url, options: [:])
             }
             */
        }
        
        if tweet.retweetCount == 0 {
            retweetCountLabel.text = ""
        } else {
            retweetCountLabel.text = "\(tweet.retweetCount)"
        }
        
        if tweet.favoriteCount == 0 {
            favoriteCountLabel.text = ""
        } else {
            favoriteCountLabel.text = "\(tweet.favoriteCount)"
        }
        
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
