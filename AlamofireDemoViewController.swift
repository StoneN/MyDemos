//
//  AlamofireDemoViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/6/1.
//  Copyright © 2017年 StoneNan. All rights reserved.
//


// test URL： //https://dn-boxue-free-video.qbox.me/ConstantAndVariable_Swift3-9781ed6f7bec16a5b48ea466496cfacd.mp4
// QUESTION: Not clear the tmp file when it user cancel downloading.


import UIKit
import Alamofire

enum DownloadStatus {
    case NotStarted
    case Downloading
    case Suspended
}

class AlamofireDemoViewController: UIViewController, UITextFieldDelegate {
    
    var currStatus = DownloadStatus.NotStarted
    var request: Alamofire.Request?
    
    @IBOutlet weak var downloadUrl: UITextField!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var suspendBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if !(self.episodesDirUrl as NSURL).checkResourceIsReachableAndReturnError(nil) {
            try! FileManager.default
                .createDirectory(at: self.episodesDirUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginBtn.isEnabled = false
        suspendBtn.isEnabled = false
        cancelBtn.isEnabled = false
        
        downloadUrl.delegate = self
        
        downloadUrl.addTarget(self, action: #selector(valueChanged(_:)), for: UIControlEvents.editingChanged)
    }
    
    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Action
    @IBAction func valueChanged(_ sender: UITextField) {
        if sender.text != "" {
            if self.currStatus == .NotStarted {
                self.beginBtn.isEnabled = true
            }
        } else {
            self.beginBtn.isEnabled = false
            self.suspendBtn.isEnabled = false
            self.cancelBtn.isEnabled = false
        }
    }

    @IBAction func beginDownload(_ sender: UIButton) {
        print("Begin downloading...")
        
        let destination: DownloadRequest.DownloadFileDestination = { temporaryUrl, response in
            print(temporaryUrl)
            
            let pathComponent = response.suggestedFilename
            let fileURL = self.episodesDirUrl.appendingPathComponent(pathComponent!)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        if let resUrl = self.downloadUrl.text {
            self.request = Alamofire.download(resUrl, to: destination)
                .downloadProgress { progress in
                    DispatchQueue.main.async() {
                        let progress = progress.fractionCompleted
                        self.downloadProgress.progress = Float(progress)
                    }
                }
                .response { response in
                    if let error = response.error {
                        if let data = response.resumeData {
                            self.displayNetworkAlert(
                                errorMessage: error.localizedDescription,
                                data: data,
                                destination: destination
                            )
                        } else {
                            self.displayNetworkAlert(errorMessage: error.localizedDescription)
                        }
                        
                    } else {
                        let alert = UIAlertController(
                            title: "Success",
                            message: "Download finished successfully!",
                            preferredStyle: .alert)
                        
                        alert.addAction(
                            UIAlertAction(title: "OK",
                                          style: UIAlertActionStyle.default,
                                          handler: { _ in
                                            print("Finish downloading...")
                                            
                                            self.currStatus = .NotStarted
                                            self.downloadUrl.text = nil
                                            self.downloadProgress.progress = 0
                                            self.beginBtn.isEnabled = false
                                            self.suspendBtn.isEnabled = false
                                            self.cancelBtn.isEnabled = false
                            }
                            )
                        )
                        self.present(alert, animated: true, completion: nil)
                    }
                }
        }
        self.currStatus = .Downloading
        self.beginBtn.isEnabled = false
        self.suspendBtn.isEnabled = true
        self.cancelBtn.isEnabled = true
    }
    
    @IBAction func suspendOrResumeDownload(_ sender: UIButton) {
        var btnTitle: String?
        
        switch self.currStatus {
        case .Downloading:
            print("Suspend downloading...")
            self.currStatus = .Suspended
            btnTitle = "Resume"
            self.request!.suspend()
            
        case .Suspended:
            print("Resume downloading...")
            self.currStatus = .Downloading
            btnTitle = "Suspend"
            self.request!.resume()

        case .NotStarted:
            break
        }
        
        self.suspendBtn.setTitle(btnTitle, for: UIControlState.normal)
    }
    
    @IBAction func cancelDownload(_ sender: UIButton) {
        print("Cancel downloading...")
        self.request?.cancel()
    }
}






extension AlamofireDemoViewController {
    fileprivate func displayNetworkAlert(
        errorMessage: String,
        data: Data? = nil,
        destination: DownloadRequest.DownloadFileDestination? = nil) {
        
        let alert = UIAlertController(title: "Network error", message: errorMessage, preferredStyle: .alert)
        if data != nil {
            let resume = UIAlertAction(
                title: "Resume",
                style: .default,
                handler: { _ in
                    print("Resume2 downloading...")
                    
                    if let destination = destination {
                        defer {
                            Alamofire.download(resumingWith: data!, to: destination)
                                .downloadProgress { progress in
                                    DispatchQueue.main.async() {
                                        let progress = progress.fractionCompleted
                                        self.downloadProgress.progress = Float(progress)
                                    }
                                }
                                .response { response in
                                    if let error = response.error {
                                        if let data = response.resumeData {
                                            self.displayNetworkAlert(
                                                errorMessage: error.localizedDescription,
                                                data: data,
                                                destination: destination
                                            )
                                        } else {
                                            self.displayNetworkAlert(errorMessage: error.localizedDescription)
                                        }
                                        
                                    } else {
                                        let alert = UIAlertController(
                                            title: "Success",
                                            message: "Download finished successfully!",
                                            preferredStyle: .alert)
                                        
                                        alert.addAction(
                                            UIAlertAction(title: "OK",
                                                          style: UIAlertActionStyle.default,
                                                          handler: { _ in
                                                            print("Finish downloading...")
                                                            
                                                            self.currStatus = .NotStarted
                                                            self.downloadUrl.text = nil
                                                            self.downloadProgress.progress = 0
                                                            self.beginBtn.isEnabled = false
                                                            self.suspendBtn.isEnabled = false
                                                            self.cancelBtn.isEnabled = false
                                                }
                                            )
                                        )
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                        }
                    }
                }
            )
            alert.addAction(resume)
            
            let cancel = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: { _ in
                    print("Cancel2 downloading...")
                    
                    self.currStatus = .NotStarted
                    self.suspendBtn.setTitle("Suspend", for: UIControlState.normal)
                    self.downloadUrl.text = nil
                    self.downloadProgress.progress = 0
                    self.beginBtn.isEnabled = false
                    self.suspendBtn.isEnabled = false
                    self.cancelBtn.isEnabled = false
                }
            )
            alert.addAction(cancel)
            
            
        } else {
            
            let cancel = UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: { _ in
                    print("Cancel3 downloading...")
                    
                    self.currStatus = .NotStarted
                    self.suspendBtn.setTitle("Suspend", for: UIControlState.normal)
                    self.downloadUrl.text = nil
                    self.downloadProgress.progress = 0
                    self.beginBtn.isEnabled = false
                    self.suspendBtn.isEnabled = false
                    self.cancelBtn.isEnabled = false
                }
            )
            alert.addAction(cancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension
AlamofireDemoViewController {
    var documentsDirUrl: URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return url
    }
    
    var episodesDirUrl: URL {
        let url = self.documentsDirUrl.appendingPathComponent("episodes", isDirectory: true)
        return url
    }
}
