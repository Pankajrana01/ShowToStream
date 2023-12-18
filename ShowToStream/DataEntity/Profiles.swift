//
//  Profiles.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 13/01/21.
//

import UIKit

class Profile: NSObject, Codable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var _id: String!
    var profileName: String!
    var profileImage: String!
    var categories: [PreferenceCategory] = []
    var genres: [PreferenceGenre] = []

    var preferencesSet: Bool {
        return !categories.isEmpty && !genres.isEmpty
    }
    var avatarImage: UIImage {
        characters.first(where: { "\($0.id)" == profileImage })?.image ?? #imageLiteral(resourceName: "Avatar1")
    }
    
    init(_id: String, profileName: String, profileImage: String) {
        self._id           = _id
        self.profileName   = profileName
        self.profileImage  = profileImage
    }

    init(rawProfile: [String: Any]) {
        super.init()
        self.updateWith(rawProfile)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "_id")
        aCoder.encode(profileName, forKey: "profileName")
        aCoder.encode(profileImage, forKey: "profileImage")
        
        aCoder.encode(categories, forKey: "categories")
        aCoder.encode(genres, forKey: "genres")
    }

    required convenience init(coder aDecoder: NSCoder) {
        let _id = aDecoder.decodeObject(forKey: "_id") as! String
        let profileName = aDecoder.decodeObject(forKey: "profileName") as! String
        let profileImage = aDecoder.decodeObject(forKey: "profileImage") as! String
        let categories = aDecoder.decodeObject(forKey: "categories") as! [PreferenceCategory]
        let genres = aDecoder.decodeObject(forKey: "genres") as! [PreferenceGenre]

        self.init(_id: _id,
                  profileName: profileName,
                  profileImage: profileImage)
        self.categories = categories
        self.genres = genres
    }

    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs._id == rhs._id
    }
    
    func updateWith(_ dic: [String: Any]) {
        if let id = dic[WebConstants.id] as? String {
            self._id = id
        }
        if let profileName = dic[WebConstants.profileName] as? String {
            self.profileName = profileName
        }
        if let profileImage = dic[WebConstants.profileImage] as? String {
            self.profileImage = profileImage
        }

        categories.removeAll()
        if let rawCategoryIds = dic[WebConstants.categoryIds] as? [String] {
            rawCategoryIds.forEach { id in
                if let category = SharedDataManager.shared.categories.first(where: { category -> Bool in
                    category._id == id
                }) {
                    categories.append(category)
                }
            }
        }
        
        genres.removeAll()
        if let rawGenreIds = dic[WebConstants.genreIds] as? [String] {
            rawGenreIds.forEach { id in
                if let genre = SharedDataManager.shared.genres.first(where: { genre -> Bool in
                    genre._id == id
                }) {
                    genres.append(genre)
                }
            }
        }
    }
}
