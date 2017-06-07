//
//  PhotoScrollCollectionViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/28.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class PhotoScrollCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
    fileprivate let reuseIdentifier = "PhotoCell"
    fileprivate let thumbnailSize: CGFloat = 70.0
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
    fileprivate let photos = ["photo1", "photo2", "photo3", "photo4", "photo5"]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell,
            let indexPath = collectionView?.indexPath(for: cell),
            let commentViewController = segue.destination as? PSCommentViewController {
            commentViewController.photoName = "photo\(indexPath.row + 1)"
        }
        
        if let cell = sender as? UICollectionViewCell,
            let indexPath = collectionView?.indexPath(for: cell),
            let pageViewController = segue.destination as? PSPageViewController {
            pageViewController.photos = photos
            pageViewController.currentIndex = indexPath.row
        }
    }
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        cell.imageView.image = UIImage(named: photos[indexPath.row])?.thumbnailOfSize(thumbnailSize)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: thumbnailSize, height: thumbnailSize)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
}
