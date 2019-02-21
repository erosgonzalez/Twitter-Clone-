//
//  TweetViewController.swift
//  Twitter
//
//  Created by Eros Gonzalez on 2/16/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tweet: UITextView!

    @IBAction func cancelBttn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweetBttn(_ sender: Any) {
        if (!tweet.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweet.text, success: {self.dismiss(animated: true, completion: nil)}, failure: {(error) in
                    print("Error\(error)")
                    self.dismiss(animated: true, completion: nil)
            })
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tweet.delegate = self
        tweet.becomeFirstResponder()
        tweet.text = "Enter Tweet"
        tweet.textColor = UIColor.lightGray

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tweet.textColor == UIColor.lightGray{
            tweet.text = nil
            tweet.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tweet.text.isEmpty{
            tweet.text = "Enter Tweet"
            tweet.textColor = UIColor.gray
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
