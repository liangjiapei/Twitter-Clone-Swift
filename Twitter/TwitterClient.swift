//
//  TwitterClient.swift
//  Twitter
//
//  Created by Jiapei Liang on 2/21/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: 	"0BE59xDSsRWCks6dyh7K1gOnM", consumerSecret: "jGnYjWylK2L7kDjLUTS6h6LASiY9tYrKjxK2tQyEQtdK46plAZ")
    
    static var max_id: Int?
    static var since_id: Int?
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitter://oauth")!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            if let requestToken = requestToken {
                let token = requestToken.token!
                print("I got a token: \(token)")
                
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            
            
            
        }, failure: { (error: Error?) in
            print("Error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        }, failure: { (error: Error?) in
            print("Error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            if let response = response {
                
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                let firstTweet: Tweet = tweets[0]
                let lastTweet: Tweet = tweets[tweets.count-1]
                
                TwitterClient.since_id = firstTweet.id
                TwitterClient.max_id = lastTweet.id
                
                success(tweets)
            }
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
    }
    
    func scrollDownToGetOldTweets(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: ["max_id" : TwitterClient.max_id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            if let response = response {
                
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                let lastTweet: Tweet = tweets[tweets.count-1]
                
                TwitterClient.max_id = lastTweet.id
                
                success(tweets)
            }
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
    }
    
    func pullToGetNewTweets(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: ["since_id" : TwitterClient.since_id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            if let response = response as? NSArray {
                
                if response.count == 0 {
                    success([])
                    return
                }
                
                print("Pull to refresh response: \(response)")
                
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                let firstTweet: Tweet = tweets[0]
                
                TwitterClient.since_id = firstTweet.id
                
                success(tweets)
            }
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
    }
    
    
    func compose(status: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        
        post("https://api.twitter.com/1.1/statuses/update.json", parameters: ["status": status], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let response = response {
                
                let tweet = response as! NSDictionary
                
                TwitterClient.since_id = tweet["id"] as? Int
                
                success(tweet)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
        
    }
    
    func reply(status: String, replyId: Int, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        
        post("https://api.twitter.com/1.1/statuses/update.json", parameters: ["status": status, "in_reply_to_status_id": replyId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let response = response {
                
                let tweet = response as! NSDictionary
                
                TwitterClient.since_id = tweet["id"] as? Int
                
                success(tweet)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
        
    }
    
    
    func favorite(id: Int, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        post("https://api.twitter.com/1.1/favorites/create.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let response = response {
                
                let tweet = response as! NSDictionary

                success(tweet)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
    }
    
    func unfavorite(id: Int, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        post("https://api.twitter.com/1.1/favorites/destroy.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let response = response {
                
                let tweet = response as! NSDictionary
                
                success(tweet)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
    }
    
    func retweet(id: Int, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        post("https://api.twitter.com/1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let response = response {
                
                let tweet = response as! NSDictionary
                
                success(tweet)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
    }
    
    func unretweet(id: Int, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        post("https://api.twitter.com/1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let response = response {
                
                let tweet = response as! NSDictionary
                
                success(tweet)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            if let response = response {
                
                let userDictionary = response as! NSDictionary
                
                let user = User(dictionary: userDictionary)
                
                success(user)
            }
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            failure(error)
            
        })
    }
    
    
}
