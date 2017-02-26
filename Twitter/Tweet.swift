//
//  Tweet.swift
//  Twitter
//
//  Created by Jiapei Liang on 1/25/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var name: String?
    var screenName: String?
    var profileImageUrl: URL?
    var favorited: Bool?
    var entities: NSDictionary?
    var urls: NSDictionary?
    var url: String?
    var displayUrl: String?
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        
        text = dictionary["text"] as? String
        
        entities = dictionary["entities"] as? NSDictionary
        
        print("my entities: \(entities)")
        
        let temp = entities?["urls"] as? NSArray
        
        if temp != nil && temp?.count != 0 {
            urls = temp![0] as! NSDictionary
            url = urls!["url"] as? String
            displayUrl = urls!["display_url"] as? String
        }
        
        favorited = dictionary["favorited"] as? Bool
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let user: NSDictionary = (dictionary["user"] as? NSDictionary) ?? [:]
        
        if user.count > 0 {
            if let profileImageUrlString = user["profile_image_url"] as? String {
                profileImageUrl = URL(string: profileImageUrlString)
            }
            
            screenName = user["screen_name"] as? String
            
            name = user["name"] as? String
        }
        
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
        
    }
    
    
}
