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
    var channelRef: FIRDatabaseReference?
    var channel: Channel? {
        didSet {
            title = channel?.name
        }
    }
    
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        try! FIRAuth.auth()!.signOut()
    }

    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FIRAuth.auth()?.currentUser?.uid)
        self.senderId = "123" //FIRAuth.auth()?.currentUser?.uid
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Collection view data source (and related) methods
    
    
    // MARK: Firebase related methods
    
    
    // MARK: UI and User Interaction
    
    
    // MARK: UITextViewDelegate methods
    
}


//    private var events: [Event] = []
//    private lazy var eventRef: FIRDatabaseReference = FIRDatabase.database().reference().child("messages").child("November 17")
//    private var eventRefHandle: FIRDatabaseHandle?

// MARK: View Lifecycle

//    private func observeEvents() {
//        eventRefHandle = eventRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
//            let eventData = snapshot.value as! Dictionary<String, AnyObject> // 2
//            let id = snapshot.key
//
//            if let event_title = eventData["event_title"] as! String!, event_title.characters.count > 0 { // 3
//                self.events.append(Event(event_id: id, event_title: event_title))
//            } else {
//                print("Error! Could not decode channel data")
//            }
//        })
//    }

