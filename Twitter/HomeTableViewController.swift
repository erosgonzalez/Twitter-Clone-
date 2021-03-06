//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Eros Gonzalez on 2/11/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadTweets()
        
        refresh.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = refresh
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    
    @objc func loadTweets(){
        numberOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: params as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.refresh.endRefreshing()
            
        }, failure: { (Error) in
            print ("ERROR: Tweet")
        })
    }
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweets += 20
        
        let params = ["count": numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: params as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print ("ERROR: Tweet")
        })
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        cell.userNameLabel.text = user["name"] as? String
        
        cell.setFavorited(tweetArray[indexPath.row]["favorited"] as! Bool)
        
        cell.setRetweet(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

   
}
