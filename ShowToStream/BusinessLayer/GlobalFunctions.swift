//
//  GlobalFunctions.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import SwiftMessages
import SVProgressHUD
import UIKit
import SDWebImage

protocol ComponentShimmers {
    var animationDuration: Double { get }
    func hideViews()
    func showViews()
    func setShimmer()
    func removeShimmer()
}


/// Shows default loader over the current screen
func showLoader() {
    SVProgressHUD.show()
}

/// Hides the loader
func hideLoader() {
    SVProgressHUD.dismiss()
}
// global functions
func delay(_ seconds: Double, f: @escaping () -> Void) {
    let delay = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delay) {
        f()
    }
}

// MARK: - Top bar
func showWorkInProgress() {
    showMessage(with: "Work in progress", theme: .warning)
}

func showMessage(with title: String, theme: Theme = .error) {
    SwiftMessages.show {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureContent(title: title , body: title, iconImage: Icon.info.image)
        view.button?.isHidden = true
        view.bodyLabel?.font = UIFont.appRegularFont(with: 15)
        view.titleLabel?.isHidden = true
        view.iconLabel?.isHidden = true
        return view
    }
}
func showSuccessMessage(with title: String, theme: Theme = .success) {
    SwiftMessages.show {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureContent(title: title , body: title, iconImage: Icon.info.image)
        view.button?.isHidden = true
        view.bodyLabel?.font = UIFont.appRegularFont(with: 12)
        view.titleLabel?.isHidden = true
        view.iconLabel?.isHidden = true
        return view
    }
}

// MARK: - Get/Set image
func getImageFromTempDirectory(_ imageName: String) -> UIImage? {
    if imageName.isLocalImageUrl {
        let tempDirectory  = NSTemporaryDirectory()
        let imageURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(imageName)
        let image = UIImage(contentsOfFile: imageURL.path)
        return image
    }
    return nil
}

func saveImageToTempDirectory(image: UIImage, specificFileName: String? = nil) -> String? {
    if let imageData = image.pngData() {
        let tempDirectory  = NSTemporaryDirectory()
        let fileName = specificFileName ?? "\(Date().timeIntervalSince1970).png"
        let imageURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(fileName)
        do {
            try imageData.write(to: imageURL)
            return fileName
        } catch {
            print("error saving file:", error)
        }
    }
    return nil
}

func downloadImage(_ url: URL, completionHandler: @escaping (String?) -> Void) {
    SDWebImage.SDWebImageDownloader.shared.downloadImage(with: url) { image, _, _, _ in
        if let image = image {
            completionHandler(saveImageToTempDirectory(image: image))
        } else {
            completionHandler(nil)
        }
    }
}
