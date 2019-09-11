//
//  ViewController.swift
//  Twitterment


import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!

    let sentimentClassifier = TweetSentimentClassifier()
    let tweetCount = 100
    
    let swifter = Swifter(consumerKey: Keys.consumerKey, consumerSecret: Keys.consumerSecret)

    override func viewDidLoad() {
        super.viewDidLoad()
        sentimentLabel.text = ""
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(clearScreen))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
    }
    
    @objc func clearScreen() {
        textField.text = nil
        sentimentLabel.text = ""
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            clearScreen()
        }
    }

    @IBAction func predictPressed(_ sender: Any) {
        textField.resignFirstResponder()
        sentimentLabel.text = "..."
        sentimentLabel.textColor = UIColor.white
        SVProgressHUD.show()
        fetchTweets()
    }
    
    // Fetch Tweets
    func fetchTweets() {
        if let userSearch = textField.text {
            // Batch predictions
            var tweets = [TweetSentimentClassifierInput]()
            swifter.searchTweet(using: userSearch, geocode: nil, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, metadata) in
                for i in 0..<self.tweetCount {
                    // Get the full_text tweets out
                    if let tweet = results[i]["full_text"].string {
                        // Turn string (tweet) into TweetSentimentClassifierInput
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                self.makePredictions(with: tweets)
            }) { (error) in
                print("Error with Twitter API request \(error.localizedDescription)")
                SVProgressHUD.dismiss()
            }
        }
    }
    
    // Make predictions
    func makePredictions(with tweets: [TweetSentimentClassifierInput]) {
        do {
            // Predictiona array
            let preditions = try self.sentimentClassifier.predictions(inputs: tweets)
            // Score
            var score = 0
            for pred in preditions {
                if pred.label == "Pos" {
                    score += 1
                } else if pred.label == "Neg" {
                    score += -1
                }
            }
            updateUI(for: score)
            SVProgressHUD.dismiss()
        } catch {
            print("Error getting model prediction")
            SVProgressHUD.dismiss()
        }
    }
    
    // Update UI
    func updateUI(for score: Int) {
        if score > 20 {
            self.sentimentLabel.text = "😍"
        } else if score > 10 {
            self.sentimentLabel.text = "😀"
        } else if score > 0 {
            self.sentimentLabel.text = "🙂"
        } else if score == 0 {
            self.sentimentLabel.text = "😐"
        } else if score > -10 {
            self.sentimentLabel.text = "😦"
        } else if score > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
}

