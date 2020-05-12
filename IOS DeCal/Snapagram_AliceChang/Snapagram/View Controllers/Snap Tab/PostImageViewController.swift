//
//  PostImageViewController.swift
//  Snapagram
//
//  Created by Alice Yewon Chang on 3/22/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class PostImageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    

    @IBOutlet weak var LocationTextField: UITextField!
    @IBOutlet weak var CaptionTextField: UITextField!
    @IBOutlet weak var ThreadCollectionView: UICollectionView!
    
    @IBOutlet weak var ImageToBePosted: UIImageView!
    var ImageToDisplay : UIImage!
    var location: String = ""
    var caption: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        ThreadCollectionView.dataSource = self
        ThreadCollectionView.delegate = self
        self.ImageToBePosted.image = ImageToDisplay
        self.location = ""
        self.caption = ""

        // Do any additional setup after loading the view.
    }
    
    @IBAction func PostButtonPressed(_ sender: Any) {
        self.location = LocationTextField.text!
        self.caption = CaptionTextField.text!
        feed.addPost(post: Post(location: location, image: ImageToDisplay, user: feed.username, caption: caption, date: Date()))
       
        _ = navigationController?.popViewController(animated: true)
        

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.threads.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let thread = feed.threads[index]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "threadCell", for: indexPath) as? PostThreadCollectionViewCell {
            cell.nameLabel.text = thread.name
            cell.emojiLabel.text = thread.emoji
            return cell
        }
        return UICollectionViewCell()
       }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // segue to preview controller with selected thread
        let index = indexPath.item
        let chosenthread = feed.threads[index]
        chosenthread.addEntry(threadEntry: ThreadEntry(username: feed.username, image: ImageToDisplay))
        _ = navigationController?.popViewController(animated: true)
    }
}
