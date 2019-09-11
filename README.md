# Twitterment
Tweet sentiment analysis with ML model made with CREATE ML

The user can type any hashtag like #love, @Trump, #Bitcoin, whatever.
The app takes the 100 most recent tweets in english language up to 280 characters (extended) and for each one it infers whether it is a positive, negative or neutral tweet.
For each positive tweet the score is increased by 1, for each negative tweet it is decreased by -1. Neutral tweets do not change the score.

NOTE: to run the app you need to get you API keys by signing up for them in Twitter. 
The API calls are managed by the Swifter framework.

In the ViewController.swift file at this line:

let swifter = Swifter(consumerKey: Keys.consumerKey, consumerSecret: Keys.consumerSecret)

you need to type your consumer and secret keys.
In this case, keys are stored in a swift file named Keys, but you can store them wherever you want.
