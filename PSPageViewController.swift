//
//  PSPageViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/30.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class PSPageViewController: UIPageViewController {

    var photos: [String]!
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let viewController = viewPhotoCommentController(index: currentIndex ?? 0) {
            let viewControllers = [viewController]
            setViewControllers (
                viewControllers,
                direction: .forward,
                animated: false,
                completion: nil
            )
        }
    }
    
    fileprivate func viewPhotoCommentController(index: Int) -> PSCommentViewController? {
        if let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "PSCommentViewController")
                as? PSCommentViewController {
            page.photoName = photos[index]
            page.photoIndex = index
            return page
        }
        
        return nil
    }
}

extension PSPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? PSCommentViewController {
            guard let index = viewController.photoIndex, index != 0 else {
                return nil
            }
            return viewPhotoCommentController(index: index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? PSCommentViewController {
            guard let index = viewController.photoIndex, index != photos.count - 1 else {
                return nil
            }
            return viewPhotoCommentController(index: index + 1)
        }
        return nil
    }
    
    /// MARK: UIPageControl
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return photos.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
    }

}
