//
//  MessagesViewController.swift
//  Joke Generator Extension MessagesExtension
//
//  Created by Robert Sun on 6/13/23.
//

import UIKit
import Messages
import MessageUI

class MessagesViewController: MSMessagesAppViewController {
    
    struct Joke: Decodable {
        let id: String
        let joke: String
        let sentiment: String
    }
    
    @IBOutlet weak var isToggled: UISwitch!
    
    @IBOutlet weak var searchField: UISearchBar!
    
    @IBOutlet weak var responseText: UITextView!
    
    func queryRegularJoke() {
        let url = URL(string: "https://jokegenerator.click/api/joke")!
        var request = URLRequest(url: url)
        let query: String = searchField.text ?? ""
        print(query)
        print(query.count)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(query, forHTTPHeaderField: "query")
        print(request)
        if let method = request.httpMethod {
            print("Method: \(method)")
        }

        if let headers = request.allHTTPHeaderFields {
            print("Headers:")
            for (key, value) in headers {
                print("\(key): \(value)")
            }
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let jokes = try? JSONDecoder().decode([Joke].self, from: data) {
                    print(jokes)
                    DispatchQueue.main.async {
                        self.responseText.text = jokes.first?.joke
                    }
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    
    func queryCleanJoke() {
        let url = URL(string: "https://jokegenerator.click/api/cleanjoke")!
        var request = URLRequest(url: url)
        let query: String = searchField.text ?? ""
        request.setValue(query, forHTTPHeaderField: "query")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(searchField.text!)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let jokes = try? JSONDecoder().decode([Joke].self, from: data) {
                    print(jokes)
                    DispatchQueue.main.async {
                        self.responseText.text = jokes.first?.joke
                    }
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    
    @IBAction func onSubmitPressed(_ sender: UIButton) {
        if isToggled.isOn {
            queryCleanJoke()
        } else {
            queryRegularJoke()
        }
    }

    @IBAction func onMessageSend(_ sender: UIButton) {
        if let searchText = responseText.text {
            UIPasteboard.general.setValue(searchText, forPasteboardType: "public.plain-text")
        }
    }
    
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var topStack: UIStackView!
    
    @IBOutlet weak var midStack: UIStackView!
    
    @IBOutlet weak var bottomStack: UIStackView!
    
    @IBAction func startClick(_ sender: UIButton) {
        if self.presentationStyle == MSMessagesAppPresentationStyle.compact {
            self.requestPresentationStyle(MSMessagesAppPresentationStyle.expanded)
        }
        startLabel.isHidden = true
        startButton.isHidden = true
        topLabel.isHidden = false
        topStack.isHidden = false
        midStack.isHidden = false
        bottomStack.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startLabel.isHidden = false
        startButton.isHidden = false
        topLabel.isHidden = true
        topStack.isHidden = true
        midStack.isHidden = true
        bottomStack.isHidden = true
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dismisses the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
