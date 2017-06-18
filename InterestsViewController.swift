//
//  InterestsViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/6/2.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class InterestsViewController: UIViewController {

    var flowLayout: UICollectionViewFlowLayout!
    var linearLayout: InterestsLinearCollectionViewLayout!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var interests = Interest.createInterests()

    private func initCollectionView() {
        //初始化flow布局
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 112, height: 152)
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
        
        //初始化自定义布局
        linearLayout = InterestsLinearCollectionViewLayout()
        
        //初始化Collection View
        collectionView.collectionViewLayout = linearLayout
        
        //Collection View代理设置
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.clear
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func changeLayout(_ sender: UIBarButtonItem) {
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        let newLayout = collectionView.collectionViewLayout.isKind(of: InterestsLinearCollectionViewLayout.self) ? flowLayout : linearLayout
        collectionView.setCollectionViewLayout(newLayout!, animated: true)
    }
    
    
}

// MARK: - UICollectionViewDataSource
extension InterestsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "Interest Cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! InterestsCollectionViewCell
        
        cell.interest = interests[(indexPath as NSIndexPath).item]
        
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension InterestsViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthWithSpace = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthWithSpace
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthWithSpace - scrollView.contentInset.left, y: -scrollView.contentInset.top)
    }
}
