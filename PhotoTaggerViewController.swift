//
//  PhotoTaggerViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/6/1.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit
import Alamofire

let kAuthorization = ""

class PhotoTaggerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    fileprivate var tags: [String]?
    fileprivate var colors: [PtPhotoColor]?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            takePictureButton.setTitle("Select Photo", for: UIControlState())
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        imageView.image = nil
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PtShowResults" {
            guard let controller = segue.destination as? PtTagsColorsViewController else {
                fatalError("Storyboard mis-configuration. Controller is not of expected type TagsColorsViewController")
            }
            
            controller.tags = tags
            controller.colors = colors
        }
    }
    
    // MARK: - Action
    @IBAction func takePicture(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .fullScreen
        }
        
        present(picker, animated: true, completion: nil)
    }
    

}

// MARK: - UIImagePickerControllerDelegate
extension PhotoTaggerViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            dismiss(animated: true)
            return
        }
        
        imageView.image = image
        
        takePictureButton.isHidden = true
        progressView.progress = 0.0
        progressView.isHidden = false
        activityIndicatorView.startAnimating()
        
        upload(
            image: image,
            progressCompletion: { [unowned self] percent in
                self.progressView.setProgress(percent, animated: true)
            },
            completion: { [unowned self] tags, colors in
                self.takePictureButton.isHidden = false
                self.progressView.isHidden = true
                self.activityIndicatorView.stopAnimating()
                
                self.tags = tags
                self.colors = colors
                
                self.performSegue(withIdentifier: "PtShowResults", sender: self)
        })
        
        dismiss(animated: true)
    }
}

extension PhotoTaggerViewController {
    func upload(image: UIImage,
                progressCompletion: @escaping (_ percent: Float) -> Void,
                completion: @escaping (_ tags: [String], _ colors: [PtPhotoColor]) -> Void) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: "imagefile",
                                         fileName: "image.jpg",
                                         mimeType: "image/jpeg")
        },
            with: ImageRouter.content,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress { progress in
                        progressCompletion(Float(progress.fractionCompleted))
                    }
                    upload.validate()
                    upload.responseJSON { response in
                        guard response.result.isSuccess else {
                            print("Error while uploading file: \(String(describing: response.result.error))")
                            completion([String](), [PtPhotoColor]())
                            return
                        }
                        
                        guard let responseJSON = response.result.value as? [String: Any],
                            let uploadedFiles = responseJSON["uploaded"] as? [Any],
                            let firstFile = uploadedFiles.first as? [String: Any],
                            let firstFileID = firstFile["id"] as? String else {
                                print("Invalid information received from service")
                                completion([String](), [PtPhotoColor]())
                                return
                        }
                        
                        print("Content uploaded with ID: \(firstFileID)")
                        
                        self.downloadTags(contentID: firstFileID) { tags in
                            self.downloadColors(contentID: firstFileID) { colors in
                                completion(tags, colors)
                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    
    func downloadTags(contentID: String, completion: @escaping ([String]) -> Void) {
        Alamofire.request(ImageRouter.tags(contentID))
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    completion([String]())
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: Any],
                    let results = responseJSON["results"] as? [[String: Any]],
                    let firstObject = results.first,
                    let tagsAndConfidences = firstObject["tags"] as? [[String: Any]] else {
                        print("Invalid tag information received from the service")
                        completion([String]())
                        return
                }
                
                let tags = tagsAndConfidences.flatMap({ dict in
                    return dict["tag"] as? String
                })
                
                completion(tags)
        }
    }
    
    func downloadColors(contentID: String, completion: @escaping ([PtPhotoColor]) -> Void) {
        Alamofire.request(ImageRouter.colors(contentID))
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Error while fetching colors: \(String(describing: response.result.error))")
                    completion([PtPhotoColor]())
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: Any],
                    let results = responseJSON["results"] as? [[String: Any]],
                    let firstResult = results.first,
                    let info = firstResult["info"] as? [String: Any],
                    let imageColors = info["image_colors"] as? [[String: Any]] else {
                        print("Invalid color information received from service")
                        completion([PtPhotoColor]())
                        return
                }
                
                let photoColors = imageColors.flatMap({ (dict) -> PtPhotoColor? in
                    guard let r = dict["r"] as? String,
                        let g = dict["g"] as? String,
                        let b = dict["b"] as? String,
                        let closestPaletteColor = dict["closest_palette_color"] as? String else {
                            return nil
                    }
                    
                    return PtPhotoColor(red: Int(r), green: Int(g), blue: Int(b), colorName: closestPaletteColor)
                })
                
                completion(photoColors)
        }
    }
}

