//
//  RetweetLikeCountsTableViewCell.swift
//  Twitter
//
//  Created by Jiapei Liang on 3/6/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class RetweetLikeCountsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
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

    func updateUI() {
        retweetButton.setTitle("\(tweet.retweetCount) RETWEETS", for: .normal)
        likeButton.setTitle("\(tweet.favoriteCount) LIKES", for: .normal)
    }

    
}
