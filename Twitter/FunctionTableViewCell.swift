//
//  FunctionTableViewCell.swift
//  Twitter
//
//  Created by Jiapei Liang on 3/6/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class FunctionTableViewCell: UITableViewCell {

    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var isFavorite = false
    var isRetweeted = false
    
    var tweet: Tweet! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    
    func handleFavorite() {
        isFavorite = true
        favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
    }
    
    func handleUnfavorite() {
        isFavorite = false
        favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
    }
    
    func handleRetweet() {
        isRetweeted = true
        retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
    }
    
    func handleUnretweet() {
        isRetweeted = false
        retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
    }
    
    
    func updateUI() {
        if tweet.favorited! {
            print("Favorited already")
            isFavorite = true
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            print("Not Favorited")
            isFavorite = false
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        
        if tweet.retweeted! {
            print("Retweeted already")
            isRetweeted = true
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            print("Not Retweeted")
            isRetweeted = false
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
    }

}
