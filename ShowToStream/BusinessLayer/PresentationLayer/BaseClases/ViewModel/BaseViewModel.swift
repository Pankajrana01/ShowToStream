//
//  BaseViewModel.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import SKPhotoBrowser
import SwiftMessages
import UIKit

class BaseViewModel: NSObject {
    weak var hostViewController: BaseViewController!

    init(hostViewController: BaseViewController) {
        super.init()
        self.hostViewController = hostViewController
    }
}

// MARK: - Photo Browser
extension BaseViewModel {
    func showBrowser(with image: UIImage) {
        SKPhotoBrowserOptions.displayCounterLabel = false
        SKPhotoBrowserOptions.displayBackAndForwardButton = false
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayHorizontalScrollIndicator = false
        SKPhotoBrowserOptions.displayVerticalScrollIndicator = false

        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(image)
        images.append(photo)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        hostViewController.present(browser,
                                   animated: true,
                                   completion: nil)
    }

    func showBrowser(with imageUrl: String) {
        SKPhotoBrowserOptions.displayCounterLabel = false
        SKPhotoBrowserOptions.displayBackAndForwardButton = false
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayHorizontalScrollIndicator = false
        SKPhotoBrowserOptions.displayVerticalScrollIndicator = false

        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(imageUrl)
        images.append(photo)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        hostViewController.present(browser,
                                   animated: true,
                                   completion: nil)
    }
}

extension BaseViewModel {
    @objc
    func viewLoaded() {
        
    }
}

// MARK: - Error Handling
extension BaseViewModel {
    
    func hasErrorIn(_ response: [String: Any]?,
                    showError: Bool = true) -> Bool {
        return BaseViewModel.hasErrorIn(response,
                                        showError: showError,
                                        hostViewController: self.hostViewController)
    }
    
    class func hasErrorIn(_ response: [String: Any]?,
                          showError: Bool = true,
                          hostViewController: BaseViewController? = nil) -> Bool {
        guard let response = response,
            let code = response[APIConstants.code],
            let message = response[APIConstants.message] as? String else {
                if showError {
                    showMessage(with: GenericErrorMessages.internalServerError)
                }
                return true
        }
        
        if "\(code)" != "200" {
            if "\(code)" == "401" { // invalid access token. should go to landing
                showMessage(with: WebConstants.logoutMesaage)
                if hostViewController != nil{
                    self.proceedToLogout(view: hostViewController!)
                }
            } else {
                // show error message form Api ...
                if showError {
                    showMessage(with: message)
                }
            }
            return true
        }
        return false
    }
    
    /// Clearing all the local data and taking user back to landing screen
    
    static func proceedToLogout(view:BaseViewController) {
        // invalid access token. should go to welcome / login screen
        UserModel.shared.logoutUser()
        VideoPlayerManager.shared.stopPlayingPipViewWhenLoggedOut(in: view)
        delay(0.5){
            KAPPDELEGATE.updateRootController(LandingViewController.getController(),
                                          transitionDirection: .fade,
                                          embedInNavigationController: true)
        }
    }

}


extension BaseViewModel {
    
    func hasErrorIn(_ response: GeneralAPiResponse?,
                    showError: Bool = true) -> Bool {
        return BaseViewModel.hasErrorIn(response,
                                        showError: showError,
                                        hostViewController: self.hostViewController)
    }
    
    class func hasErrorIn(_ response: GeneralAPiResponse?,
                          showError: Bool = true,
                          hostViewController: BaseViewController? = nil) -> Bool {
        guard let response = response else {
            if showError {
                showMessage(with: GenericErrorMessages.internalServerError)
            }
            return true
        }
        
        if response.statusCode != 200 {
            if showError {
                showMessage(with: response.message)
            }
            if response.statusCode == 401 { // invalid access token. should go to welcome / login screen
//                UserModel.shared.logoutUser()
//                hostViewController?.gotoWelcomeScreen()
            }
            return true
        }
        return false
    }
}

// MARK: - Photo handling
extension BaseViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func choosePhoto(isCamera: Bool) {
        if isCamera == true {
            checkPermission(.camera, permissionType: .camera)
        } else {
            checkPermission(.photoLibrary, permissionType: .photos)
        }
    }

    func checkPermission(_ sourceType: UIImagePickerController.SourceType,
                         permissionType: PermissionType) {
        let permissionManager = PermissionManager()
        let status = permissionManager.status(permissionType)
        if status.isAuthorized() {
            showImagePickerWith(sourceType)
        } else if permissionManager.canRequestPermission(permissionType: permissionType) {
            permissionManager.requestPermission(permissionType: permissionType) { granted in
                if granted {
                    self.showImagePickerWith(sourceType)
                } else {
                    permissionManager.showRestrictedAlert(permissionType,
                                                          host: self.hostViewController)
                }
            }
        } else {
            permissionManager.showRestrictedAlert(permissionType,
                                                  host: self.hostViewController)
        }
    }
    
    private func showImagePickerWith(_ sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourceType
            self.hostViewController.present(imagePicker,
                                            animated: true,
                                            completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}
