//
//  PermissionManager.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import Photos
import CoreLocation
import UIKit

public enum PermissionType {
    case locationAlways, locationInUse, camera, video, photos
}

public enum PermissionStatus: Int {
    case authorized = 0
    case denied = 1
    case notDetermined = 2
    
    func isAuthorized() -> Bool {
        return self == .authorized
    }
}

class PermissionManager: NSObject {

    public func canRequestPermission( permissionType: PermissionType) -> Bool {
        let status = self.status(permissionType)
        return status == .notDetermined
    }

    public func requestPermission( permissionType: PermissionType, completion: @escaping (Bool) -> Void ) {
        let status = self.status(permissionType)
        if status == .notDetermined {
            switch permissionType {
            case .video:
                requestCameraAccess(completion: completion)
            case .camera:
                requestCameraAccess(completion: completion)
            case .photos:
                requestPhotosAccess(completion: completion)
            case .locationInUse:
                requestPhotosAccess(completion: completion)
            default:
                fatalError("Permission type not impemented")
            }
        } else {
            completion(status == .authorized)
        }
    }
    
    public func status(_ permissionType: PermissionType) -> PermissionStatus {
        switch permissionType {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .authorized:
                return .authorized
            case .denied, .restricted:
                return .denied
            default:
                return .notDetermined
            }
        case .photos:
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .denied, .restricted:
                return .denied
            default:
                return .notDetermined
            }

        case .locationInUse:
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .denied, .restricted:
                return .denied
            default:
                return .notDetermined
            }
        default:
            fatalError("Permission type not impemented")
        }
    }
    
    /**
     This method requests for camera permissions.
     */
    private func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            completion(granted)
        }
    }
    
    public func showRestrictedAlert(_ permissionType: PermissionType, host: UIViewController) {
        DispatchQueue.main.async {
            switch permissionType {
            case .camera:
                host.showAlert(with: "",
                               message: "Camera permission denied.",
                               options: "Cancel",
                               "Settings") { index in
                                if index == 1,
                                    let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url,
                                                              options: [:],
                                                              completionHandler: nil)
                                }
                }
            case .photos:
                host.showAlert(with: "",
                               message: "Gallery permission denied.",
                               options: "Cancel",
                               "Settings") { index in
                                if index == 1,
                                    let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url,
                                                              options: [:],
                                                              completionHandler: nil)
                                }
                }
            case .locationInUse:
                host.showAlert(with: "",
                               message: "Location permission denied.",
                               options: "Cancel",
                               "Settings") { index in
                                if index == 1,
                                    let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url,
                                                              options: [:],
                                                              completionHandler: nil)
                                }
                }
            default:
                fatalError("Permission type not impemented")
            }
        }
    }
    
    /**
     This method requests for camera permissions.
     */
    private func requestPhotosAccess(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization({ status in
            completion(status == .authorized)
        })
    }
}
