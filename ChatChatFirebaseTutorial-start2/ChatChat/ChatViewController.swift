/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase
import JSQMessagesViewController

final class ChatViewController: JSQMessagesViewController {
    
    // MARK: Properties
    var userRef: FIRDatabaseReference?
    private lazy var messageRef: FIRDatabaseReference = self.userRef!.child("messages")
    private var newMessageRefHandle: FIRDatabaseHandle?
    
    private var events = [Event]()
    private var eventRef: FIRDatabaseReference?
    private var eventRefHandle: FIRDatabaseHandle?
    
    var channel: Channel? {
        didSet {
            title = channel?.name
        }
    }
    
    var messages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    //    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
    //        dismiss(animated: true, completion: nil)
    //        try! FIRAuth.auth()!.signOut()
    //    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        
        print("this is the message ref: \(messageRef)")
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        observeEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    deinit {
        if let refHandle = eventRefHandle {
            eventRef?.removeObserver(withHandle: refHandle)
        }
    }
    
    // MARK: Collection view data source (and related) methods
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    // MARK: Firebase related methods
    
    //    override func didPressSend(_ button: UIButton!,
    //                               withMessageText text: String!,
    //                               senderId: String!,
    //                               senderDisplayName: String!,
    //                               date: Date!) {
    //        print("works!")
    //    }
    
//    override func didPressAccessoryButton(_ sender: UIButton!) {
//        print("works for accessory")
//    }
    
    private func observeEvents() {
        let todayDateString = getTodayDateString()
        self.eventRef = FIRDatabase.database().reference().child("events").child(todayDateString)
        eventRefHandle = eventRef?.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let eventData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            
            if let event_title = eventData["event_title"] as! String! { // 3
                print(event_title)
                self.events.append(Event(event_id: id, event_title: event_title))
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    // MARK: UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    // MARK: UITextViewDelegate methods
    
    //get today's date
    func getTodayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        let stringDate = formatter.string(from: Date())
        return stringDate
    }
}
