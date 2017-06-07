//
//  PSCommentViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/30.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class PSCommentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    
    var photoName: String!
    var photoIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        imageView.image = UIImage(named: photoName)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        imageView.isUserInteractionEnabled = false
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        imageView.isUserInteractionEnabled = true
        return true
    }
    
    @IBAction func closeKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        imageView.isUserInteractionEnabled = true
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImageSegue" {
            let destination = segue.destination as! PSZoomedPhotoViewController
            destination.photoName = self.photoName
        }
    }
    

}
