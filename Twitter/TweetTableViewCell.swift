//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Eros Gonzalez on 2/11/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var retweetBtnn: UIButton!
    @IBOutlet weak var favButtn: UIButton!
    
    var favorited:Bool = false
    var retweeted:Bool = false
    var tweetId:Int = -1
    
    @IBAction func retweetAct(_ sender: Any) {
        let tobeRetweeted = !retweeted
        
        if (tobeRetweeted){
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {self.setRetweet(true)}, failure: {(error) in
                print ("ERROR: Retweet \(error)")
            })
        }
        else{
            TwitterAPICaller.client?.unretweet(tweetId: tweetId, success: {self.setRetweet(false)}, failure: {(error) in
                print ("ERROR: Unretweet \(error)")
            })
        }
    }
    
    @IBAction func facAct(_ sender: Any) {
        let tobeFav = !favorited
        
        if (tobeFav){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {self.setFavorited(true)}, failure: { (error) in
                print ("ERROR: Favorite \(error)")
            })
        }
        else{
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {self.setFavorited(false)}, failure: { (error) in
                print ("ERROR: Unfavorite \(error)")
            })
        }
    }
    
    func setFavorited(_ isFavorited:Bool){
        favorited = isFavorited
        
        if (favorited){
            favButtn.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else{
             favButtn.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweet(_ isRetweeted:Bool){
        retweeted = isRetweeted
        
        if (retweeted){
            retweetBtnn.setImage(UIImage(named: "retweet-icon-green"), for:UIControl.State.normal)
            retweetBtnn.isEnabled = false
        }
        else{
            retweetBtnn.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetBtnn.isEnabled = true
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

}
