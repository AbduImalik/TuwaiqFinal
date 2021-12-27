//
//  PostCell.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 09/05/1443 AH.
//

import UIKit

class PostCell: UITableViewCell {


    var tags: [String] = []
    
    
    //
    
    
    @IBOutlet weak var userStackView: UIStackView!{
        didSet{
            userStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userStackViewTap)))
        }
    }
    @IBOutlet weak var tagsCollectionView: UICollectionView!{
        didSet{
            tagsCollectionView.dataSource = self
            tagsCollectionView.delegate = self
        }
    }

    @IBOutlet weak var postLikeLabel: UILabel!
    @IBOutlet weak var postUserImageView: UIImageView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func userStackViewTap(){
        NotificationCenter.default.post(name: NSNotification.Name("userStackViewTap"), object: nil, userInfo: ["cell" : self])
    }
}

extension PostCell : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "PostTagCell", for: indexPath) as! PostTagCell
        cell.postTagLabel.text = tags[indexPath.row]
        return cell
    }
    
    
}
