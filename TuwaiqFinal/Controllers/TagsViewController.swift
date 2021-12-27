//
//  TagsViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 17/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView
class TagsViewController: UIViewController {

    var tags :[String] = []
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        
        // Do any additional setup after loading the view.
        loaderView.startAnimating()
        PostAPI.getAllTags { tags in
            self.loaderView.stopAnimating()
            self.tags = tags
            self.tagsCollectionView.reloadData()
        }
        
    }
    

}


extension TagsViewController : UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let currentTag = tags[indexPath.row]
        cell.tagNameLabel.text = currentTag
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTag = tags[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
        vc.tags = selectedTag
        self.present(vc,animated: true)
    }
    
}
