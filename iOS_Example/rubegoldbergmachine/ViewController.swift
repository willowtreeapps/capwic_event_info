//
//  ViewController.swift
//  rubegoldbergmachine
//
//  Created by WillowTree Inc. on 3/7/19.
//
// Note: This program is incomplete. There are 5 TODOs in this file for you to address ;)

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startButton: UIButton!
    
    let client: FirebaseClient = FirebaseClient()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // This method gets called when the user presses the Start button
    @IBAction func startListening(sender: Any?) {
        // update the UI
        startButton.isEnabled = false
        self.activityIndicator.startAnimating()
        
        // check the trigger every 5 seconds
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkTrigger), userInfo: nil, repeats: true)
    }
    
    @objc func checkTrigger() {
        // TODO: Pass in the name of the document you wish to check (instead of team.json)
        self.client.get(doc: "team.json") { [weak self] (json, err) in
            guard let document = json else {
                if let err = err {
                    print("ERROR OCCURRED: \(err)")
                } else {
                    print("ERROR OCCURRED: 😭")
                }
                return
            }
            
            // TODO: You'll need to add custom comparison logic depending on
            // the contract between this component and the one preceeding it
            if let value = document["trigger"] as? Int, value == 1 {
                // if the check passes, we want to cancel the timer, reset the UI,
                // and do something fun! To manipulate the UI, we have to dispatch
                // to the main thread (this completion block will be running on a
                // background thread).
                DispatchQueue.main.async {
                    self?.timer?.invalidate()
                    self?.startButton.isEnabled = true
                    self?.activityIndicator.stopAnimating()
                    self?.doSomethingFun()
                }
            }
        }
    }
    
    // This is where we do something fun
    func doSomethingFun() {
        // TODO: Add some custom fun!
        print("DOING SOMETHING FUN 🎉🤣🎉")
        
        // TODO: Notify the next person in line when you're done having fun
        // sendTrigger()
    }
    
    // Call this to notify the next team in line
    func sendTrigger() {
        // TODO: Update these parameters the specify the name of the document you want to update
        // along with its JSON contents (specified as the dictionary type: [String: Any])
        self.client.send(doc: "team.json", data: ["KEY": "VALUE"]) { (err) in
            if let err = err {
                print("ERROR OCCURRED: \(err)")
            } else {
                print("TRIGGER SENT! 👍")
            }
        }
    }
}

