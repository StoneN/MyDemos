//
//  CollectionViewDemo1ViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/6/3.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class CollectionViewDemo1ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    
    let photos = [
        ["name":"photo1", "pic":"r1.png"],
        ["name":"photo2", "pic":"r2.png"],
        ["name":"photo3", "pic":"r3.png"],
        ["name":"photo4", "pic":"r4.png"],
        ["name":"photo5", "pic":"r5.png"],
        ["name":"photo6", "pic":"r6.png"],
        ["name":"photo7", "pic":"r3.png"],
        ["name":"photo8", "pic":"r4.png"],
        ["name":"photo9", "pic":"r5.png"],
        ["name":"photo10", "pic":"r6.png"],
        ["name":"photo11", "pic":"r1.png"],
        ["name":"photo12", "pic":"r2.png"],
        ["name":"photo13", "pic":"r4.png"],
        ["name":"photo14", "pic":"r1.png"],
        ["name":"photo15", "pic":"r5.png"],
        ["name":"photo16", "pic":"r2.png"],
        ["name":"photo17", "pic":"r3.png"],
        ["name":"photo18", "pic":"r6.png"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = CollectionViewDemo1Layout()
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewDemo1Cell")
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.view.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "CollectionViewDemo1Cell"
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as UICollectionViewCell
        
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        
        let imageView = UIImageView(image: UIImage(named: photos[indexPath.item]["pic"]!))
        imageView.frame = cell.bounds
        imageView.contentMode = .scaleToFill
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: 20))
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        titleLabel.text = photos[indexPath.item]["name"]
        cell.addSubview(imageView)
        cell.addSubview(titleLabel)
        
        return cell
    }

}
