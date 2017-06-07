//
//  InterestsLinearCollectionViewLayout.swift
//  MyDemos
//
//  Created by StoneNan on 2017/6/3.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class InterestsLinearCollectionViewLayout: UICollectionViewFlowLayout {

    var itemWidth: CGFloat = 168
    var itemHeight: CGFloat = 228
    
    override func prepare() {
        super.prepare()
        
        self.itemSize = CGSize(width: self.itemWidth, height: self.itemHeight)
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = self.collectionView!.bounds.width / 2 - itemWidth + 40
        //self.minimumLineSpacing = 20
        
        let left = (self.collectionView!.bounds.width - itemWidth) / 2
        let top = (self.collectionView!.bounds.height - itemHeight) / 2
        
        self.sectionInset = UIEdgeInsetsMake(top, left, top, left)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            //从父类得到默认的所有元素属性
            let array = super.layoutAttributesForElements(in: rect)
            
            //可见区域（目前显示出来的位于collection view上的矩形区域）
            let visiableRect = CGRect(x: self.collectionView!.contentOffset.x,
                                      y: self.collectionView!.contentOffset.y,
                                      width: self.collectionView!.frame.width,
                                      height: self.collectionView!.frame.height)
            
            //当前屏幕中点，相对于collect view上的x坐标
            let centerX = self.collectionView!.contentOffset.x
                + self.collectionView!.bounds.width / 2
            
            //这个是为了计算缩放比例的
            let maxDeviation = self.collectionView!.bounds.width / 2 + itemWidth / 2
            
            for attributes in array! {
                //与可见区域做碰撞，如果该单元格没显示则直接跳过
                if !visiableRect.intersects(attributes.frame) {continue}
                //显示的单元根据偏移量决定放大倍数（最大放大1.8倍，而离屏幕中央越远的单元格缩放的越小）
                let scale = 1 + (0.5 - abs(centerX - attributes.center.x) / maxDeviation)
                attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        return array
    }
    
    override func targetContentOffset(forProposedContentOffset
        proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        //停止滚动时的可见区域
        let lastRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y,
                              width: self.collectionView!.bounds.width,
                              height: self.collectionView!.bounds.height)
        //当前屏幕中点，相对于collect view上的x坐标
        let centerX = proposedContentOffset.x + self.collectionView!.bounds.width / 2
        //这个可见区域内所有的单元格属性
        let array = self.layoutAttributesForElements(in: lastRect)
        
        //需要移动的距离
        var adjustOffsetX = CGFloat(MAXFLOAT);
        for attri in array! {
            //每个单元格里中点的偏移量
            let deviation = attri.center.x - centerX
            //保存偏移最小的那个
            if abs(deviation) < abs(adjustOffsetX) {
                adjustOffsetX = deviation
            }
        }
        //通过偏移量返回最终停留的位置
        return CGPoint(x: proposedContentOffset.x + adjustOffsetX, y: proposedContentOffset.y)
    }
}
