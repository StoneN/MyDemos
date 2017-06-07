//
//  PSZoomedPhotoViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/29.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class PSZoomedPhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var photoName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: photoName)
        scrollView.contentSize = imageView.bounds.size
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.delegate = self
    }
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func backToComment(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

