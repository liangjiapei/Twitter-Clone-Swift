//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Jiapei Liang on 2/21/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize tableView
        tableView.delegate = self
        tableView.dataSource = self
         tableView.rowHeight = UITableViewAutomaticDimension
         tableView.estimatedRowHeight = 120

        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            
            self.tweets = tweets
            
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        TwitterClient.sharedInstance?.logout()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
        
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
