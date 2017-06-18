//
//  CollectionViewDemo1Layout.swift
//  MyDemos
//
//  Created by StoneNan on 2017/6/3.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class CollectionViewDemo1Layout: UICollectionViewLayout {

    override var collectionViewContentSize: CGSize {
        let width = collectionView!.bounds.size.width - collectionView!.contentInset.left - collectionView!.contentInset.right
        let height = CGFloat((collectionView!.numberOfItems(inSection: 0) + 1) / 3) * (width / 3 * 2)
        
        return CGSize(width: width, height: height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array = [UICollectionViewLayoutAttributes]()
        let cellCount = collectionView!.numberOfItems(inSection: 0)
        for i in 0..<cellCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = self.layoutAttributesForItem(at: indexPath)
            array.append(attributes!)
        }
        return array
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let largeCellSide = collectionViewContentSize.width / 3 * 2
        let smallCellSide = collectionViewContentSize.width / 3
        
        let line = indexPath.item / 3
        let lineOriginY = largeCellSide * CGFloat(line)
        
        let rightLargeX = collectionViewContentSize.width - largeCellSide
        let rightSmallX = collectionViewContentSize.width - smallCellSide
        
        if (indexPath.item % 6 == 0) {
            attributes.frame = CGRect(x: 0,
                                      y: lineOriginY,
                                      width: largeCellSide,
                                      height: largeCellSide)
        } else if (indexPath.item % 6 == 1) {
            attributes.frame = CGRect(x: rightSmallX,
                                      y: lineOriginY,
                                      width: smallCellSide,
                                      height: smallCellSide)
        } else if (indexPath.item % 6 == 2) {
            attributes.frame = CGRect(x:rightSmallX,
                                     y:lineOriginY + smallCellSide,
                                     width:smallCellSide,
                                     height:smallCellSide)
        } else if (indexPath.item % 6 == 3) {
            attributes.frame = CGRect(x:0, y:lineOriginY,
                                     width:smallCellSide,
                                     height:smallCellSide )
        } else if (indexPath.item % 6 == 4) {
            attributes.frame = CGRect(x:0,
                                     y:lineOriginY + smallCellSide,
                                     width:smallCellSide,
                                     height:smallCellSide)
        } else if (indexPath.item % 6 == 5) {
            attributes.frame = CGRect(x:rightLargeX, y:lineOriginY,
                                     width:largeCellSide,
                                     height:largeCellSide)
        }
        return attributes
    }
    
    
    
}
