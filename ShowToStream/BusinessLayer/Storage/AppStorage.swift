//
//  AppStorage.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

private let encryptionKey   = "showtostream2021"
private let iv              = "streamtoshow2020"

extension String {
    var aesEncrypted: String {
        let cryptLib = CryptLib()
        return cryptLib.encryptPlainTextRandomIV(withPlainText: self, key: encryptionKey)
    }
    
    var aesDecrypted: String {
        let cryptLib = CryptLib()
        return cryptLib.decryptCipherTextRandomIV(withCipherText: self, key: encryptionKey)
    }
    
    var aesCryptoJS: String {
        // Load only what's necessary
        let AES = CryptoJS.AES()
        
        // AES encryption
        return AES.encrypt(self, password: encryptionKey)
        
//        // AES encryption with custom mode and padding
//        _ = CryptoJS.mode.ECB() // Load custom mode
//        _ = CryptoJS.pad.Iso97971() // Load custom padding scheme
//        return AES.encrypt(self, password: encryptionKey, options:[ "mode": CryptoJS.mode().ECB, "padding": CryptoJS.pad().Iso97971 ])

    }
}

struct AES {
    
    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data
    
    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }
        
        
        self.key = keyData
        self.iv  = ivData
    }
    
    
    // MARK: - Function
    // MARK: Public
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }
    
    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

class AppStorage: NSObject {
    
    static let shared = AppStorage()
    
    private override init(){
    }
    
    private let aes128 = AES(key: encryptionKey, iv: iv)

    private func decryptedValueForKey(key: String) -> String {
        if let encryptedData = UserDefaults.standard.value(forKey: key) as? Data,
           let decryptedData = aes128?.decrypt(data: encryptedData) {
            return decryptedData
        } else {
            return ""
        }
    }
    
    private func storeValue(value: String, for key: String) {
        UserDefaults.standard.set(aes128?.encrypt(string: value), forKey: key)
    }
    var user: User? {
        get {
            if let rawUser = UserDefaults.standard.data(forKey: "user"),
               let user = try? NSKeyedUnarchiver.unarchivedObject(ofClass: User.self, from: rawUser) {
                return user
            }
            return nil
        }
        set(newValue) {
            if let newValue = newValue {
                let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: "user")
            } else {
                UserDefaults.standard.set(nil, forKey: "user")
            }
        }
    }

    var fcmToken: String{
        get {
            decryptedValueForKey(key: "fcmToken")
        }
        set(newValue) {
            storeValue(value: newValue, for: "fcmToken")
        }
    }
    var continueAsGuest: Bool {
        get {
            decryptedValueForKey(key: "continueAsGuest") == "Yes"
        }
        set(newValue) {
            storeValue(value: newValue ? "Yes" : "No", for: "continueAsGuest")
        }
    }
    var skipWalkthrough: Bool {
        get {
            decryptedValueForKey(key: "skipWalkthrough") == "Yes"
        }
        set(newValue) {
            storeValue(value: newValue ? "Yes" : "No", for: "skipWalkthrough")
        }
    }
    var skipWelcomeMessage: Bool {
        get {
            decryptedValueForKey(key: "skipWelcomeMessage") == "Yes"
        }
        set(newValue) {
            storeValue(value: newValue ? "Yes" : "No", for: "skipWelcomeMessage")
        }
    }
    var s3Url: String {
        get {
            decryptedValueForKey(key: "s3Url")
        }
        set(newValue) {
            storeValue(value: newValue, for: "s3Url")
        }
    }
    var userPicDirectoryName: String {
        get {
            decryptedValueForKey(key: "userPicDirectoryName")
        }
        set(newValue) {
            storeValue(value: newValue, for: "userPicDirectoryName")
        }
    }
    
    
    func clearAll()  {
        let defaults = UserDefaults.standard
        defaults.synchronize()
    }
}

extension AppStorage {
    var hasSetPreferences: Bool {
        get {
            decryptedValueForKey(key: "hasSetPreferences") == "Yes"
        }
        set(newValue) {
            storeValue(value: newValue ? "Yes" : "No", for: "hasSetPreferences")
        }
    }

    var categories: [PreferenceCategory] {
        get {
            if let data = UserDefaults.standard.data(forKey: "categories") {
                let decoder = JSONDecoder()
                let objects = try? decoder.decode([PreferenceCategory].self, from: data)
                return objects ?? []
            } else {
                return []
            }
        }
        set(newValue) {
            let encode = JSONEncoder()
            let encodedValue = try? encode.encode(newValue)
            UserDefaults.standard.set(encodedValue, forKey: "categories")
        }
    }

    var genres: [PreferenceGenre] {
        get {
            if let data = UserDefaults.standard.data(forKey: "genres") {
                let decoder = JSONDecoder()
                let objects = try? decoder.decode([PreferenceGenre].self, from: data)
                return objects ?? []
            } else {
                return []
            }
        }
        set(newValue) {
            let encode = JSONEncoder()
            let encodedValue = try? encode.encode(newValue)
            UserDefaults.standard.set(encodedValue, forKey: "genres")
        }
    }
}

extension AppStorage {
    
    var profiles: [Profile] {
        get {
            if let data = UserDefaults.standard.data(forKey: "profiles") {
                let decoder = JSONDecoder()
                let objects = try? decoder.decode([Profile].self, from: data)
                return objects ?? []
            } else {
                return []
            }
        }
        set(newValue) {
            let encode = JSONEncoder()
            let encodedValue = try? encode.encode(newValue)
            UserDefaults.standard.set(encodedValue, forKey: "profiles")
        }
    }
}
