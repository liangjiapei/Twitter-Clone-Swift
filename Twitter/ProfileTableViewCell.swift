//
//  ProfileTableViewCell.swift
//  Twitter
//
//  Created by Jiapei Liang on 3/6/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var tweetsButton: UIButton!
    
    @IBOutlet weak var displayUrlTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView.setImageWith((User.currentUser?.profileUrl)!)
        nameLabel.text = User.currentUser?.name
        if let screenName = User.currentUser?.screenname {
            screenNameLabel.text = "@\(screenName)"
        }
        
        if let followerCount = User.currentUser?.followerCount {
            followerButton.setTitle("\(followerCount) FOLLOWERS", for: .normal)
        }
        
        if let followingCount = User.currentUser?.followingCount {
            followingButton.setTitle("\(followingCount) FOLLOWING", for: .normal)
        }
        
        if let tweetsCount = User.currentUser?.tweetsCount {
            tweetsButton.setTitle("\(tweetsCount) TWEETS", for: .normal)
        }
        
        
        
        // displayUrlTextView.text = User.currentUser?.displayUrl
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
