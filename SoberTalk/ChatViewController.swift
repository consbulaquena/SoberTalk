//
//  ChatViewController.swift
//  SoberTalk
//
//  Created by Cons Bulaqueña on 21/04/2018.
//  Copyright © 2018 consios. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class ChatViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    var messageRef = FIRDatabase.database().reference().child("messages")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = FIRAuth.auth()?.currentUser
        {
            self.senderId = currentUser.uid
            
            if currentUser.isAnonymous == true
            {
                self.senderDisplayName = "anonymous"
            } else
            {
                self.senderDisplayName = "\(currentUser.displayName!)"
            }
            
        }
        
        observeMessages()
    }
    
    func observeUsers(_ id: String)
    {
        FIRDatabase.database().reference().child("users").child(id).observe(.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: AnyObject]
            {
                let avatarUrl = dict["profileUrl"] as! String
                
                self.setupAvatar(avatarUrl, messageId: id)
            }
        })
        
    }
    
    func setupAvatar(_ url: String, messageId: String)
    {
        if url != "" {
            let fileUrl = URL(string: url)
            let data = try? Data(contentsOf: fileUrl!)
            let image = UIImage(data: data!)
            let userImg = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
            self.avatarDict[messageId] = userImg
            self.collectionView.reloadData()
            
        } else {
            avatarDict[messageId] = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "profileImage"), diameter: 30)
            collectionView.reloadData()
        }
        
    }
    
    func observeMessages() {
        messageRef.observe(.childAdded, with: { snapshot in
            // print(snapshot.value)
            if let dict = snapshot.value as? [String: AnyObject] {
                let mediaType = dict["MediaType"] as! String
                let senderId = dict["senderId"] as! String
                let senderName = dict["senderName"] as! String
                
                self.observeUsers(senderId)
                switch mediaType {
                    
                case "TEXT":
                    
                    let text = dict["text"] as! String
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                    
                case "PHOTO":
                    //                    var photo = JSQPhotoMediaItem(image: nil)
                    //                    let fileUrl = dict["fileUrl"] as! String
                    //
                    //                    if let cachedPhoto = self.photoCache.objectForKey(fileUrl) as? JSQPhotoMediaItem {
                    //                        photo = cachedPhoto
                    //                        self.collectionView.reloadData()
                    //                    } else {
                    //                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), {
                    //                            let data = NSData(contentsOfURL: NSURL(string: fileUrl)!)
                    //                            dispatch_async(dispatch_get_main_queue(), {
                    //                                let image = UIImage(data: data!)
                    //                                photo.image = image
                    //                                self.collectionView.reloadData()
                    //                                self.photoCache.setObject(photo, forKey: fileUrl)
                    //                            })
                    //                        })
                    //                    }
                    let photo = JSQPhotoMediaItem(image: nil)
                    let fileUrl = dict["fileUrl"] as! String
                    let downloader = SDWebImageDownloader.shared()
                    downloader?.downloadImage(with: URL(string: fileUrl)!, options: [], progress: nil, completed: { (image, data, error, finished) in
                        DispatchQueue.main.async(execute: {
                            photo?.image = image
                            self.collectionView.reloadData()
                        })
                    })
                    
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                    
                    if self.senderId == senderId {
                        photo?.appliesMediaViewMaskAsOutgoing = true
                    } else {
                        photo?.appliesMediaViewMaskAsOutgoing = false
                    }
                    
                    
                case "VIDEO":
                    
                    let fileUrl = dict["fileUrl"] as! String
                    let video = URL(string: fileUrl)!
                    let videoItem = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: videoItem))
                    
                    if self.senderId == senderId {
                        videoItem?.appliesMediaViewMaskAsOutgoing = true
                    } else {
                        videoItem?.appliesMediaViewMaskAsOutgoing = false
                    }
                    
                default:
                    print("unknown data type")
                    
                }
                
                self.collectionView.reloadData()
                
            }
        })
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        //        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        //        collectionView.reloadData()
        //        print(messages)
        let newMessage = messageRef.childByAutoId()
        let messageData = ["text": text, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "TEXT"]
        newMessage.setValue(messageData)
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("didPressAccessoryButton")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    
    //Returns bubble msg
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        if message.senderId == self.senderId {

            return bubbleFactory!.outgoingMessagesBubbleImage(with: UIColor(red: 40/255, green: 147/255, blue: 250/255, alpha: 1))
        } else {

            return bubbleFactory!.outgoingMessagesBubbleImage(with: UIColor(red: 245/255, green: 246/255, blue: 248/255, alpha: 1))
            
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        
        return avatarDict[message.senderId]
        //return JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "profileImage"), diameter: 30)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of items: \(messages.count)")
        return messages.count
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId {
            cell.textView!.textColor = UIColor.white
        }
        else {
            cell.textView!.textColor = UIColor.black
        }
        
        return cell
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutDidTapped(_ sender: Any) {
        
        //create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // from main instantiate a View(login) controller
        
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        //get app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        // set loginVC controller as root
        appDelegate.window?.rootViewController = loginVC
    }

}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did finish picking")
        // get the image
        print(info)
        let picture = info[UIImagePickerControllerOriginalImage] as? UIImage
        let photo = JSQPhotoMediaItem(image: picture!)
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
        
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
        
}


