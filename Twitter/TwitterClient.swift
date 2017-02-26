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
                
                success(tweets)
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
