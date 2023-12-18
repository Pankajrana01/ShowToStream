//
//  Show.swift
//  ShowToStream
//
//  Created by Applify on 17/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
import AVKit

class Show : NSObject {
    
    var _id : String?
    var contentThumbnail : String?
    var title : String?
    var subtitle : String?
    var contentDescription : String?
    var playDuration : String?
    var totalPlayDuration : String?
    var payPerViewPrice: String?
    var keyword: String?
    var image: UIImage?
    var name: String = "The Sleeping Beauty"
    var tag: String?
    var genre: [String] = []
    var categories: [String] = []
    var addedToWatchlist: Bool = false
    var trailerUrl: String = "" { didSet { trailerUrlDidSet() } }
    var streamUrl: String = "" { didSet { urlDidSet() } }
    var trailerAsset: AVAsset?
    var urlAsset: AVAsset?
    var timeLeft : String?
    var categoryId: String?
    var categoryName:String?
    var isDanceStudioPrivate: Bool = false
    
    var paymentType: String?
    var payPerViewStatus:Bool = false
    var buyToOwnStatus:Bool = false
    var buyToOwnPrice: String?
    var sequenceContentId: [SequenceContentIds]?

    private func trailerUrlDidSet() {
        if let url = URL(string: trailerUrl) {
            trailerAsset = AVAsset(url: url)
        }
    }

    private func urlDidSet() {
        if let url = URL(string: streamUrl) {
            urlAsset = AVAsset(url: url)
        }
    }

    var producer: [String] = []
    var director: [String] = []
    var starCast: [String] = []
    var writer: [String] = []
    var kids: [String] = []
    var dataDic = [String:Any]()

    var displaybleGenreAndCategories: String {
        var newArray = [String]()
        newArray.append(contentsOf: categories)
        newArray.append(contentsOf: genre)
        return newArray.joined(separator: "  •  ")
    }

    var displaybleProducerAndGenre: String {
        var newArray = [String]()
        newArray.append(contentsOf: producer)
        newArray.append(contentsOf: categories)
        newArray.append(contentsOf: genre)
        return newArray.joined(separator: "  •  ")
    }

    var displaybleDescription: NSAttributedString {
//        var newString = self.contentDescription ?? "" + "\n"
        var newString = ""
        
        var boldStrins: [String] = []
        var producersCombined = ""
        newString = ""
        let keysArray = dataDic.keys
        var reqKeysArray = NSMutableArray()
        reqKeysArray.removeAllObjects()
        var indexOfKey = -1
        
        if dataDic.keys.contains("Subtitle") || dataDic.keys.contains("SUBTITLE") {
            indexOfKey = indexOfKey + 1
            if dataDic.keys.contains("Subtitle") {
                reqKeysArray[indexOfKey] = "Subtitle"
            } else {
                reqKeysArray[indexOfKey] = "SUBTITLE"
            }
        }
        
        if dataDic.keys.contains("Description") || dataDic.keys.contains("DESCRIPTION") {
            indexOfKey = indexOfKey + 1
            if dataDic.keys.contains("Description") {
                reqKeysArray[indexOfKey] = "Description"
            } else {
                reqKeysArray[indexOfKey] = "DESCRIPTION"
            }
        }
        
        if dataDic.keys.contains("Producer") || dataDic.keys.contains("PRODUCER") {
            indexOfKey = indexOfKey + 1
            if dataDic.keys.contains("Producer") {
                reqKeysArray[indexOfKey] = "Producer"
            } else {
                reqKeysArray[indexOfKey] = "PRODUCER"
            }
        }
        
        if dataDic.keys.contains("Actor") || dataDic.keys.contains("ACTOR") {
            indexOfKey = indexOfKey + 1
            if dataDic.keys.contains("Actor") {
                reqKeysArray[indexOfKey] = "Actor"
            } else {
                reqKeysArray[indexOfKey] = "ACTOR"
            }
        }
        
        if dataDic.keys.contains("Director") || dataDic.keys.contains("DIRECTOR") {
            indexOfKey = indexOfKey + 1
            if dataDic.keys.contains("Director") {
                reqKeysArray[indexOfKey] = "Director"
            } else {
                reqKeysArray[indexOfKey] = "DIRECTOR"
            }
        }
        
        for i in 0 ..< reqKeysArray.count {
            var writerCombined = ""
            let kyy = reqKeysArray[i] as! String
            
            if kyy == WebConstants.showSubTitle {
                let kyy = reqKeysArray[i] as! String
                var writerString = "\(WebConstants.reqShowSubTitle.capitalizingFirstLetter()): "
                //"\(kyy.capitalizingFirstLetter()): "
                writerCombined = dataDic[kyy] as! String
                writerString += writerCombined
                newString += "\n" + writerString + "\n"
                boldStrins.append("\(WebConstants.reqShowSubTitle.capitalizingFirstLetter()): ")
            } else if kyy == WebConstants.showDesc {
                let kyy = reqKeysArray[i] as! String
                var writerString = "\(WebConstants.reqShowDesc): "
                //"\(kyy.capitalizingFirstLetter()): "
                writerCombined = dataDic[kyy] as! String
                writerString += writerCombined
                newString += "\n" + writerString + "\n"
                boldStrins.append("\(WebConstants.reqShowDesc): ")
            } else if let nameAry = dataDic[kyy] as? [String] {
                var writerString = "\(kyy.capitalizingFirstLetter()): "

                if nameAry.count == 1 {
                    writerCombined = nameAry[0]
                } else {
                    var starCastArrayExceptLast = nameAry
                    starCastArrayExceptLast.removeLast()
                    writerCombined = starCastArrayExceptLast.joined(separator: ", ")
                    writerCombined += " and " + nameAry.last!
                }
                writerString += writerCombined
                newString += "\n" + writerString + "\n"
                boldStrins.append("\(kyy.capitalizingFirstLetter()): ")
            }
        }
        
        let attrString = NSMutableAttributedString(string: newString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 15
        paragraphStyle.maximumLineHeight = 15
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: paragraphStyle,
                                range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(NSAttributedString.Key.font,
                                value: UIFont.appLightFont(with: 12),
                                range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: UIColor.appLightGray,
                                range: NSRange(location: 0, length: attrString.length))

        boldStrins.forEach {
            let range = (newString as NSString).range(of: $0)
            attrString.addAttribute(NSAttributedString.Key.font,
                                    value: UIFont.appSemiBoldFont(with: 12),
                                    range: range)
            attrString.addAttribute(NSAttributedString.Key.foregroundColor,
                                    value: UIColor.white,
                                    range: range)
        }
        return attrString
    }

    var progress: Float = 0.0
    var applause: Int = 0
    var standingOvation: Int = 0
    var price: Double = 0
    var isPurchased: Bool = false
    var totalTime: String?
    var subscriptionTimeLeft = ""
    var isApplause: Bool?
    var isStandingOvation: Bool?

    //MARK: Set data in show model..
    func updateWithHomeData(_ dic: [String: Any]){
        if let id = dic[WebConstants.id] as? String {
            self._id = id
        }
        // title
        if let title = dic[WebConstants.title] as? String {
            self.title = title
        }
        // subtitle
        if let subtitle = dic[WebConstants.subtitle] as? String {
            self.subtitle = subtitle
        }
        // keyword
        if let keyword = dic[WebConstants.keyword] as? String {
            self.keyword = keyword
        }
        
        // trailerUrl
        if let trailerUrl = dic[WebConstants.trailerFile] as? String {
            self.trailerUrl = trailerUrl
        }
        
        //urlAsset
        if let streamUrl = dic[WebConstants.streamFile] as? String {
            self.streamUrl = streamUrl
        }
        // contentThumbnail
        if let contentThumbnail = dic[WebConstants.contentThumbnail] as? String {
            self.contentThumbnail = contentThumbnail
        }
        
        // contentDescription
        if let contentDescription = dic[WebConstants.contentDescription] as? String {
            self.contentDescription = contentDescription
        }
        
        // playDuration
        if let playDuration = dic[WebConstants.playDuration] as? String {
            self.playDuration = playDuration
        }
        
        // payPerViewPrice
        if let payPerViewPrice = dic[WebConstants.payPerViewPrice] as? Double {
            let strPrice = "\(payPerViewPrice)"
            if strPrice.contains(".00") || strPrice.contains(".0") {
                self.payPerViewPrice = "\(Int(payPerViewPrice))"
            } else {
                self.payPerViewPrice = String(format: "%.2f", payPerViewPrice)
            }
        }
        
        // buyToOwnPrice
        if let buyToOwnPrice = dic[WebConstants.buyToOwnPrice] as? Double {
            let strPrice = "\(buyToOwnPrice)"
            if strPrice.contains(".00")  || strPrice.contains(".0"){
                self.buyToOwnPrice = "\(Int(buyToOwnPrice))"
            } else {
                self.buyToOwnPrice = String(format: "%.2f", buyToOwnPrice)
            }
        }
        
        // buyToOwnStatus
        if let buyToOwnStatus = dic[WebConstants.buyToOwnStatus] as? Bool {
            self.buyToOwnStatus = buyToOwnStatus
        }
        
        // buyToOwnStatus
        if let paymentType = dic[WebConstants.paymentType] as? Int {
            self.paymentType = "\(paymentType)"
        }
        
        // buyToOwnStatus
        if let payPerViewStatus = dic[WebConstants.payPerViewStatus] as? Bool {
            self.payPerViewStatus = payPerViewStatus
        }
        // applause
        if let applause = dic[WebConstants.applause] as? Int {
            self.applause = applause
        }
        
        // standingOvation
        if let standingOvation = dic[WebConstants.standingOvation] as? Int {
            self.standingOvation = standingOvation
        }
        
        // show tag
        if let tag = dic[WebConstants.trending] as? String {
            self.tag = tag
        }
        // add watchlist
        if let inWatchList = dic[WebConstants.inWatchList] as? Bool {
            self.addedToWatchlist = inWatchList
        }
        
        //isPurchased
        if let isPurchased = dic[WebConstants.isPurchased] as? Bool {
            self.isPurchased = isPurchased
        }
        
        // casting
        if let casting = dic[WebConstants.casting] as? [[String:Any]] {
             producer = []
             director = []
             starCast = []
            writer = []
            kids = []
            dataDic.removeAll()

            var keysArray: [String] = []
            var valuesArray: [String] = []
            var keyName = ""
            if self.subtitle != "" && self.subtitle != nil{
                dataDic[WebConstants.showSubTitle] = self.subtitle
            }
            
            if self.contentDescription != "" && self.contentDescription != nil{
                dataDic[WebConstants.showDesc] = self.contentDescription
            }
            
            for cast in 0..<casting.count {
                if !keysArray.contains(casting[cast][WebConstants.role] as! String) {
                    valuesArray = []
                    keyName =  casting[cast][WebConstants.role] as! String
                    valuesArray.append(casting[cast][WebConstants.name] as! String)
                    keysArray.append(casting[cast][WebConstants.role] as! String)
                    //print("name: \(casting[cast][WebConstants.name] as! String)")
                }else if casting[cast][WebConstants.role] as! String == keyName{
                   // print("name else: \(casting[cast][WebConstants.name] as! String)")
                    valuesArray.append(casting[cast][WebConstants.name] as! String)
                }else {
                    keyName =  casting[cast][WebConstants.role] as! String
                    var tempValuesArray = dataDic[casting[cast][WebConstants.role] as! String] as! [String]
                    tempValuesArray.append(casting[cast][WebConstants.name] as! String)
                    valuesArray.removeAll()
                    valuesArray = tempValuesArray
                }
                
                dataDic[keyName] = valuesArray
//                keysArray = []
//                keyName = ""
            }
            
            
            
            
//            let values = casting.map { $0["role"] as? String == "SINGER"
//                if !keysArray.contains($0["role"] as! String) {
//                    keyName =  $0["role"] as! String
//                    valuesArray.append($0["name"] as! String)
//                    keysArray.append($0["role"] as! String)
//                    print("name: \($0["name"] as! String)")
//                }else{
//                    print("name else: \($0["name"] as! String)")
//                    valuesArray.append($0["name"] as! String)
//                }
//
//                dataDic[keyName] = valuesArray
//                keysArray = []
//                valuesArray = []
//                keyName = ""
//            }
//            print(values)
            
            //print("keysArray: \(keysArray)")
           // print("dataDic: \(dataDic)")

            
//            for cast in 0..<casting.count {
//                if !keysArray.contains(casting[cast][WebConstants.role] as! String) {
//                    valuesArray = []
//                    keyName =  casting[cast][WebConstants.role] as! String
//                    valuesArray.append(casting[cast][WebConstants.name] as! String)
//                    keysArray.append(casting[cast][WebConstants.role] as! String)
//                    print("name: \(casting[cast][WebConstants.name] as! String)")
//                }else{
//                    print("name else: \(casting[cast][WebConstants.name] as! String)")
//                    valuesArray.append(casting[cast][WebConstants.name] as! String)
//                }
//
//                dataDic[keyName] = valuesArray
////                keysArray = []
////                keyName = ""
//            }
        }
        
        // categories
//        if let categories = dic[WebConstants.categories] as? [String:Any] {
//            if let categoryId = categories[WebConstants.id] as? String {
//                self.categoryId = categoryId
//            }
//            
//            if let categoryName = categories[WebConstants.name] as? String {
//                self.categoryName = categoryName
//            }
//        }
        
        // categories
        if let categories = dic[WebConstants.categories] as? [String:Any] {
            if let categoryId = categories[WebConstants.id] as? String {
                self.categoryId = categoryId
            }
            
            if let categoryName = categories[WebConstants.name] as? String {
                self.categoryName = categoryName
            }
        }
        
        // categories Array
        if let categoriesArray = dic[WebConstants.categories] as? [String] {
            self.categories = []
            if categoriesArray.count != 0{
                
                
                if let data = UserDefaults.standard.data(forKey: "categories") {
                    let decoder = JSONDecoder()
                    let objects = try? decoder.decode([PreferenceCategory].self, from: data)
                    print(objects)
                    if objects?.count ?? 0 >  0{
                        for i in 0 ..< (objects?.count)! {
                            if categoriesArray[0] == objects?[i]._id {
                                self.categories.append(objects?[i].name ?? "Dance")
                            }
                        }
                    }
                } else {
                    self.categories.append("Dance")
                }
                
//                let filtered_list:[PreferenceCategory] = KAPPSTORAGE.categories.filter({$0._id < categoriesArray[0]})
//                if filtered_list.count != 0{
//                    print(filtered_list[0].name)
//                    self.categories.append(filtered_list[0].name)
//                }else{
//                    self.categories.append("Dance")
//                }
            }else{
                self.categories.append("Dance")
            }
        }
        // genre Array
        if let genresArray = dic[WebConstants.genres] as? [String] {
            self.genre = []
            if genresArray.count != 0{
                
                if let data = UserDefaults.standard.data(forKey: "genres") {
                    let decoder = JSONDecoder()
                    let objects = try? decoder.decode([PreferenceGenre].self, from: data)
                    print(objects)
                    if objects?.count ?? 0 >  0{
                        for i in 0 ..< (objects?.count)! {
                            if genresArray[0] == objects?[i]._id {
                                self.genre.append(objects?[i].name ?? "Play")
                            }
                        }
                    }
                } else {
                    self.genre.append("Play")
                }
                
//                let filtered_list:[PreferenceGenre] = KAPPSTORAGE.genres.filter({$0._id < genresArray[0]})
//                if filtered_list.count != 0{
//                    print(filtered_list[0].name)
//                    self.genre.append(filtered_list[0].name)
//                }else{
//                    self.genre.append("Play")
//                }
            }else{
                self.genre.append("Play")
            }
        }
    }
    
    //MARK: Set data in show model..
    func updateWithTrendingData(_ dic: [String: Any]){
        if let contentDetails = dic[WebConstants.contentDetails] as? [[String:Any]]{
            print(contentDetails)
            
            if let dict = contentDetails.first{
                
                if let id = dict[WebConstants.id] as? String {
                    self._id = id
                }
                // title
                if let title = dict[WebConstants.title] as? String {
                    self.title = title
                }
                // subtitle
                if let subtitle = dict[WebConstants.subtitle] as? String {
                    self.subtitle = subtitle
                }
                
                // trailerUrl
                if let trailerUrl = dic[WebConstants.trailerFile] as? String {
                    self.trailerUrl = trailerUrl
                }
                //urlAsset
                if let streamUrl = dic[WebConstants.streamFile] as? String {
                    self.streamUrl = streamUrl
                }
                // contentThumbnail
                if let contentThumbnail = dict[WebConstants.contentThumbnail] as? String {
                    self.contentThumbnail = contentThumbnail
                }
                
                // contentDescription
                if let contentDescription = dict[WebConstants.contentDescription] as? String {
                    self.contentDescription = contentDescription
                }
                
                // playDuration
                if let playDuration = dict[WebConstants.playDuration] as? String {
                    self.playDuration = playDuration
                }
                
                // payPerViewPrice
                if let payPerViewPrice = dic[WebConstants.payPerViewPrice] as? Double {
                    let strPrice = "\(payPerViewPrice)"
                    if strPrice.contains(".00") || strPrice.contains(".0") {
                        self.payPerViewPrice = "\(Int(payPerViewPrice))"
                    } else {
                        self.payPerViewPrice = String(format: "%.2f", payPerViewPrice)
                    }
                }
                
                // buyToOwnPrice
                if let buyToOwnPrice = dic[WebConstants.buyToOwnPrice] as? Double {
                    let strPrice = "\(buyToOwnPrice)"
                    if strPrice.contains(".00")  || strPrice.contains(".0"){
                        self.buyToOwnPrice = "\(Int(buyToOwnPrice))"
                    } else {
                        self.buyToOwnPrice = String(format: "%.2f", buyToOwnPrice)
                    }
                }
                
                // buyToOwnStatus
                if let buyToOwnStatus = dic[WebConstants.buyToOwnStatus] as? Bool {
                    self.buyToOwnStatus = buyToOwnStatus
                }
                
                // buyToOwnStatus
                if let paymentType = dic[WebConstants.paymentType] as? Int {
                    self.paymentType = "\(paymentType)"
                }
                
                // buyToOwnStatus
                if let payPerViewStatus = dic[WebConstants.payPerViewStatus] as? Bool {
                    self.payPerViewStatus = payPerViewStatus
                }
                // applause
                if let applause = dict[WebConstants.applause] as? Int {
                    self.applause = applause
                }
                //isDanceStudioPrivate
                if let isDanceStudioPrivate = dic[WebConstants.isDanceStudioPrivate] as? Bool {
                    self.isDanceStudioPrivate = isDanceStudioPrivate
                }
                // standingOvation
                if let standingOvation = dict[WebConstants.standingOvation] as? Int {
                    self.standingOvation = standingOvation
                }
                
                // show tag
                if let tag = dict[WebConstants.trending] as? String {
                    self.tag = tag
                }
                // add watchlist
                if let inWatchList = dic[WebConstants.inWatchList] as? Bool {
                    self.addedToWatchlist = inWatchList
                }
                // casting
                if let casting = dict[WebConstants.casting] as? [[String:Any]] {
                    producer = []
                    director = []
                    starCast = []
                    writer = []
                    kids = []
                    
                    dataDic.removeAll()

                    var keysArray: [String] = []
                    var valuesArray: [String] = []
                    var keyName = ""
                    if self.subtitle != "" && self.subtitle != nil{
                        dataDic[WebConstants.showSubTitle] = self.subtitle
                    }
                    
                    if self.contentDescription != "" && self.contentDescription != nil{
                        dataDic[WebConstants.showDesc] = self.contentDescription
                    }
                    
                    for cast in 0..<casting.count {
                        if !keysArray.contains(casting[cast][WebConstants.role] as! String) {
                            valuesArray = []
                            keyName =  casting[cast][WebConstants.role] as! String
                            valuesArray.append(casting[cast][WebConstants.name] as! String)
                            keysArray.append(casting[cast][WebConstants.role] as! String)
                            print("name: \(casting[cast][WebConstants.name] as! String)")
                        }else if casting[cast][WebConstants.role] as! String == keyName{
                            print("name else: \(casting[cast][WebConstants.name] as! String)")
                            valuesArray.append(casting[cast][WebConstants.name] as! String)
                        }else {
                            keyName =  casting[cast][WebConstants.role] as! String
                            var tempValuesArray = dataDic[casting[cast][WebConstants.role] as! String] as! [String]
                            tempValuesArray.append(casting[cast][WebConstants.name] as! String)
                            valuesArray.removeAll()
                            valuesArray = tempValuesArray
                        }
                        
                        dataDic[keyName] = valuesArray
        //                keysArray = []
        //                keyName = ""
                    }
                    
                    
                    
                    
//                    let values = casting.map { $0["role"] as? String == "SINGER"
//                        if !keysArray.contains($0["role"] as! String) {
//                            keyName =  $0["role"] as! String
//                            valuesArray.append($0["name"] as! String)
//                            keysArray.append($0["role"] as! String)
//                            print("name: \($0["name"] as! String)")
//                        }else{
//                            print("name else: \($0["name"] as! String)")
//                            valuesArray.append($0["name"] as! String)
//                        }
//
//                        dataDic[keyName] = valuesArray
//                        keysArray = []
//                        valuesArray = []
//                        keyName = ""
//                    }
//                    print(values)
                    
//                    print("keysArray: \(keysArray)")
//                    print("dataDic: \(dataDic)")
                    
//                    for cast in 0..<casting.count {
//                        if casting[cast][WebConstants.role] as! String == WebConstants.director {
//
//                            self.director.append(casting[cast][WebConstants.name] as! String)
//                        }
//                        else if casting[cast][WebConstants.role] as! String == WebConstants.producer {
//
//                            self.producer.append(casting[cast][WebConstants.name] as! String)
//                        }
//                        else if casting[cast][WebConstants.role] as! String == WebConstants.actor {
//
//                            self.starCast.append(casting[cast][WebConstants.name] as! String)
//                        }else if casting[cast][WebConstants.role] as! String == WebConstants.writer {
//
//                            self.writer.append(casting[cast][WebConstants.name] as! String)
//                        }else if casting[cast][WebConstants.role] as! String == WebConstants.kids {
//
//                            self.kids.append(casting[cast][WebConstants.name] as! String)
//                        }
//                    }
                }
                
                // categories
//                if let categories = dict[WebConstants.categories] as? [String:Any] {
//                    if let categoryId = categories[WebConstants.id] as? String {
//                        self.categoryId = categoryId
//                    }
//
//                    if let categoryName = categories[WebConstants.name] as? String {
//                        self.categoryName = categoryName
//                    }
//                }
                
                // categories
                if let categories = dic[WebConstants.categories] as? [String:Any] {
                    if let categoryId = categories[WebConstants.id] as? String {
                        self.categoryId = categoryId
                    }
                    
                    if let categoryName = categories[WebConstants.name] as? String {
                        self.categoryName = categoryName
                    }
                }
                
                // categories Array
                if let categoriesArray = dic[WebConstants.categories] as? [String] {
                    self.categories = []
                    if categoriesArray.count != 0{
                        
                        
                        if let data = UserDefaults.standard.data(forKey: "categories") {
                            let decoder = JSONDecoder()
                            let objects = try? decoder.decode([PreferenceCategory].self, from: data)
                            print(objects)
                            if objects?.count ?? 0 >  0{
                                for i in 0 ..< (objects?.count)! {
                                    if categoriesArray[0] == objects?[i]._id {
                                        self.categories.append(objects?[i].name ?? "Dance")
                                    }
                                }
                            }
                        } else {
                            self.categories.append("Dance")
                        }
                        
        //                let filtered_list:[PreferenceCategory] = KAPPSTORAGE.categories.filter({$0._id < categoriesArray[0]})
        //                if filtered_list.count != 0{
        //                    print(filtered_list[0].name)
        //                    self.categories.append(filtered_list[0].name)
        //                }else{
        //                    self.categories.append("Dance")
        //                }
                    }else{
                        self.categories.append("Dance")
                    }
                }
                // categories Array
                if let genresArray = dic[WebConstants.genres] as? [String] {
                    self.genre = []
                    if genresArray.count != 0{
                        
                        if let data = UserDefaults.standard.data(forKey: "genres") {
                            let decoder = JSONDecoder()
                            let objects = try? decoder.decode([PreferenceGenre].self, from: data)
                            print(objects)
                            if objects?.count ?? 0 >  0{
                                for i in 0 ..< (objects?.count)! {
                                    if genresArray[0] == objects?[i]._id {
                                        self.genre.append(objects?[i].name ?? "Play")
                                    }
                                }
                            }
                        } else {
                            self.genre.append("Play")
                        }
                        
        //                let filtered_list:[PreferenceGenre] = KAPPSTORAGE.genres.filter({$0._id < genresArray[0]})
        //                if filtered_list.count != 0{
        //                    print(filtered_list[0].name)
        //                    self.genre.append(filtered_list[0].name)
        //                }else{
        //                    self.genre.append("Play")
        //                }
                    }else{
                        self.genre.append("Play")
                    }
                }
            }
        }
    }
    
    //MARK: Set data in show model..
    func updateWithDetailData(_ dic: [String: Any]){
      // add dummy trailer ...
        
        if let id = dic[WebConstants.id] as? String {
            self._id = id
        }
        
        // sequenceContentId
        if let sequenceContentId = dic[WebConstants.sequenceContentId] as? [[String: Any]] {
            self.sequenceContentId = []

            for item in sequenceContentId {
                let ids = SequenceContentIds()
                ids.updateWithData(item)
                self.sequenceContentId?.append(ids)
            }
        }
        
        // trailerUrl
        if let trailerUrl = dic[WebConstants.trailerFile] as? String {
            self.trailerUrl = trailerUrl
        }
        //urlAsset
        if let streamUrl = dic[WebConstants.streamFile] as? String {
            self.streamUrl = streamUrl
        }
        // title
        if let title = dic[WebConstants.title] as? String {
            self.title = title
        }
        
        // subtitle
        if let subtitle = dic[WebConstants.subtitle] as? String {
            self.subtitle = subtitle
        }
        
        // contentThumbnail
        if let contentThumbnail = dic[WebConstants.contentThumbnail] as? String {
            self.contentThumbnail = contentThumbnail
        }
        
        // contentDescription
        if let contentDescription = dic[WebConstants.contentDescription] as? String {
            self.contentDescription = contentDescription
        }
        
        // playDuration
        if let playDuration = dic[WebConstants.playDuration] as? String {
            self.playDuration = playDuration
        }
        
        // payPerViewPrice
        if let payPerViewPrice = dic[WebConstants.payPerViewPrice] as? Double {
            let strPrice = "\(payPerViewPrice)"
            if strPrice.contains(".00") || strPrice.contains(".0") {
                self.payPerViewPrice = "\(Int(payPerViewPrice))"
            } else {
                self.payPerViewPrice = String(format: "%.2f", payPerViewPrice)
            }
        }
        
        // buyToOwnPrice
        if let buyToOwnPrice = dic[WebConstants.buyToOwnPrice] as? Double {
            let strPrice = "\(buyToOwnPrice)"
            if strPrice.contains(".00")  || strPrice.contains(".0"){
                self.buyToOwnPrice = "\(Int(buyToOwnPrice))"
            } else {
                self.buyToOwnPrice = String(format: "%.2f", buyToOwnPrice)
            }
        }
        
        // buyToOwnStatus
        if let buyToOwnStatus = dic[WebConstants.buyToOwnStatus] as? Bool {
            self.buyToOwnStatus = buyToOwnStatus
        }
        
        // buyToOwnStatus
        if let paymentType = dic[WebConstants.paymentType] as? Int {
            self.paymentType = "\(paymentType)"
        }
        
        // buyToOwnStatus
        if let payPerViewStatus = dic[WebConstants.payPerViewStatus] as? Bool {
            self.payPerViewStatus = payPerViewStatus
        }
        // applause
        if let applause = dic[WebConstants.applause] as? Int {
            self.applause = applause
        }
        
        //isDanceStudioPrivate
        if let isDanceStudioPrivate = dic[WebConstants.isDanceStudioPrivate] as? Bool {
            self.isDanceStudioPrivate = isDanceStudioPrivate
        }
        
        //isApplause
        if let isApplause = dic[WebConstants.isApplause] as? Bool {
            self.isApplause = isApplause
        }
        
        //isStandingOvation
        if let isStandingOvation = dic[WebConstants.isStandingOvation] as? Bool {
            self.isStandingOvation = isStandingOvation
        }
        
        // standingOvation
        if let standingOvation = dic[WebConstants.standingOvation] as? Int {
            self.standingOvation = standingOvation
        }
        
        // show tag
        if let tag = dic[WebConstants.trending] as? String {
            self.tag = tag
        }
        // add watchlist
        if let inWatchList = dic[WebConstants.inWatchList] as? Bool {
            self.addedToWatchlist = inWatchList
        }
        
        //isPurchased
        if let isPurchased = dic[WebConstants.isPurchased] as? Bool {
            self.isPurchased = isPurchased
        }
        
        // casting
        if let casting = dic[WebConstants.casting] as? [[String:Any]] {
             producer = []
             director = []
             starCast = []
            writer = []
            kids = []
            
            dataDic.removeAll()

            var keysArray: [String] = []
            var valuesArray: [String] = []
            var keyName = ""
            if self.subtitle != "" && self.subtitle != nil{
                dataDic[WebConstants.showSubTitle] = self.subtitle
            }
            
            if self.contentDescription != "" && self.contentDescription != nil{
                dataDic[WebConstants.showDesc] = self.contentDescription
            }
            
            
            for cast in 0..<casting.count {
                if !keysArray.contains(casting[cast][WebConstants.role] as! String) {
                    valuesArray = []
                    keyName =  casting[cast][WebConstants.role] as! String
                    valuesArray.append(casting[cast][WebConstants.name] as! String)
                    keysArray.append(casting[cast][WebConstants.role] as! String)
                    print("name: \(casting[cast][WebConstants.name] as! String)")
                }else if casting[cast][WebConstants.role] as! String == keyName{
                    print("name else: \(casting[cast][WebConstants.name] as! String)")
                    valuesArray.append(casting[cast][WebConstants.name] as! String)
                }else {
                    keyName =  casting[cast][WebConstants.role] as! String
                    var tempValuesArray = dataDic[casting[cast][WebConstants.role] as! String] as! [String]
                    tempValuesArray.append(casting[cast][WebConstants.name] as! String)
                    valuesArray.removeAll()
                    valuesArray = tempValuesArray
                }
                
                dataDic[keyName] = valuesArray
//                keysArray = []
//                keyName = ""
            }
            
            
            
            
//            let values = casting.map { $0["role"] as? String == "SINGER"
//                if !keysArray.contains($0["role"] as! String) {
//                    keyName =  $0["role"] as! String
//                    valuesArray.append($0["name"] as! String)
//                    keysArray.append($0["role"] as! String)
//                    print("name: \($0["name"] as! String)")
//                }else{
//                    print("name else: \($0["name"] as! String)")
//                    valuesArray.append($0["name"] as! String)
//                }
//
//                dataDic[keyName] = valuesArray
//                keysArray = []
//                valuesArray = []
//                keyName = ""
//            }
//            print(values)
            
//            print("keysArray: \(keysArray)")
//            print("dataDic: \(dataDic)")
// for cast in 0..<casting.count {
//                if casting[cast][WebConstants.role] as! String == WebConstants.director {
//
//                    self.director.append(casting[cast][WebConstants.name] as! String)
//                }
//                else if casting[cast][WebConstants.role] as! String == WebConstants.producer {
//
//                    self.producer.append(casting[cast][WebConstants.name] as! String)
//                }
//                else if casting[cast][WebConstants.role] as! String == WebConstants.actor {
//
//                    self.starCast.append(casting[cast][WebConstants.name] as! String)
//                }else if casting[cast][WebConstants.role] as! String == WebConstants.writer {
//
//                    self.writer.append(casting[cast][WebConstants.name] as! String)
//                }else if casting[cast][WebConstants.role] as! String == WebConstants.kids {
//
//                    self.kids.append(casting[cast][WebConstants.name] as! String)
//                }
//            }
        }
        
        // categories
        if let categories = dic[WebConstants.categories] as? [String:Any] {
            if let categoryId = categories[WebConstants.id] as? String {
                self.categoryId = categoryId
            }
            
            if let categoryName = categories[WebConstants.name] as? String {
                self.categoryName = categoryName
            }
        }
        
        // categories Array
        if let categoriesArray = dic[WebConstants.categories] as? [String] {
            self.categories = []
            if categoriesArray.count != 0{
                
                
                if let data = UserDefaults.standard.data(forKey: "categories") {
                    let decoder = JSONDecoder()
                    let objects = try? decoder.decode([PreferenceCategory].self, from: data)
                    print(objects)
                    if objects?.count ?? 0 >  0{
                        for i in 0 ..< (categoriesArray.count) {
                            for j in 0 ..< (objects!.count) {
                                if categoriesArray[i] == objects?[j]._id {
                                    self.categories.append(objects?[j].name ?? "Dance")
                                }
                            }
                        }
                    }
                } else {
                    self.categories.append("Dance")
                }
            }else{
                self.categories.append("Dance")
            }
        }
        // genre Array
        if let genresArray = dic[WebConstants.genres] as? [String] {
            self.genre = []
            if genresArray.count != 0{
                
                if let data = UserDefaults.standard.data(forKey: "genres") {
                    let decoder = JSONDecoder()
                    let objects = try? decoder.decode([PreferenceGenre].self, from: data)
                    print(objects)
                    if objects?.count ?? 0 >  0{
                        for i in 0 ..< (genresArray.count) {
                            for j in 0 ..< (objects!.count) {
                                if genresArray[i] == objects?[j]._id {
                                    self.genre.append(objects?[j].name ?? "Play")
                                }
                            }
                        }
                    }
                } else {
                    self.genre.append("Play")
                }
            }else{
                self.genre.append("Play")
            }
        }
    }
    //MARK: Set Watchlist data in show model..
    func updateWithWatchlistData(_ dic: [String: Any]){
    // get content ..
        if let content = dic[WebConstants.contentId] as? [String:Any]{
            print(content)
            // get content_id
            if let id = content[WebConstants.id] as? String {
                self._id = id
            }
            // title
            if let title = content[WebConstants.title] as? String {
                self.title = title
            }
            // subtitle
            if let subtitle = content[WebConstants.subtitle] as? String {
                self.subtitle = subtitle
            }
            
            // contentThumbnail
            if let contentThumbnail = content[WebConstants.contentThumbnail] as? String {
                self.contentThumbnail = contentThumbnail
            }
            // trailerUrl
            if let trailerUrl = dic[WebConstants.trailerFile] as? String {
                self.trailerUrl = trailerUrl
            }
            //urlAsset
            if let streamUrl = dic[WebConstants.streamFile] as? String {
                self.streamUrl = streamUrl
            }
            // contentDescription
            if let contentDescription = content[WebConstants.contentDescription] as? String {
                self.contentDescription = contentDescription
            }
            
            // playDuration
            if let playDuration = content[WebConstants.playDuration] as? String {
                self.playDuration = playDuration
            }
            
            // payPerViewPrice
            if let payPerViewPrice = content[WebConstants.payPerViewPrice] as? Double {
                let strPrice = "\(payPerViewPrice)"
                if strPrice.contains(".00") || strPrice.contains(".0") {
                    self.payPerViewPrice = "\(Int(payPerViewPrice))"
                } else {
                    self.payPerViewPrice = String(format: "%.2f", payPerViewPrice)
                }
                //"\(payPerViewPrice)"
            }
            
            // buyToOwnPrice
            if let buyToOwnPrice = content[WebConstants.buyToOwnPrice] as? Double {
                let strPrice = "\(buyToOwnPrice)"
                if strPrice.contains(".00") || strPrice.contains(".0"){
                    self.buyToOwnPrice = "\(Int(buyToOwnPrice))"
                } else {
                    self.buyToOwnPrice = String(format: "%.2f", buyToOwnPrice)
                }
               // self.buyToOwnPrice = String(format: "%.2f", buyToOwnPrice)
                // "\(buyToOwnPrice)"
            }
            
            // buyToOwnStatus
            if let buyToOwnStatus = content[WebConstants.buyToOwnStatus] as? Bool {
                self.buyToOwnStatus = buyToOwnStatus
            }
            
            // buyToOwnStatus
            if let paymentType = content[WebConstants.paymentType] as? Int {
                self.paymentType = "\(paymentType)"
            }
            
            // buyToOwnStatus
            if let payPerViewStatus = content[WebConstants.payPerViewStatus] as? Bool {
                self.payPerViewStatus = payPerViewStatus
            }
            // applause
            if let applause = content[WebConstants.applause] as? Int {
                self.applause = applause
            }
            //isDanceStudioPrivate
            if let isDanceStudioPrivate = dic[WebConstants.isDanceStudioPrivate] as? Bool {
                self.isDanceStudioPrivate = isDanceStudioPrivate
            }
            // standingOvation
            if let standingOvation = content[WebConstants.standingOvation] as? Int {
                self.standingOvation = standingOvation
            }
    
            //isPurchased
            if let isPurchased = dic[WebConstants.isPurchased] as? Bool {
                self.isPurchased = isPurchased
            }
            
            dataDic.removeAll()

            if let casting = content[WebConstants.casting] as? [[String:Any]] {

            var keysArray: [String] = []
            var valuesArray: [String] = []
            var keyName = ""
                
                if self.subtitle != "" && self.subtitle != nil{
                    dataDic[WebConstants.showSubTitle] = self.subtitle
                }
                
                if self.contentDescription != "" && self.contentDescription != nil{
                    dataDic[WebConstants.showDesc] = self.contentDescription
                }
                
                for cast in 0..<casting.count {
                    if !keysArray.contains(casting[cast][WebConstants.role] as! String) {
                        valuesArray = []
                        keyName =  casting[cast][WebConstants.role] as! String
                        valuesArray.append(casting[cast][WebConstants.name] as! String)
                        keysArray.append(casting[cast][WebConstants.role] as! String)
                        print("name: \(casting[cast][WebConstants.name] as! String)")
                    }else if casting[cast][WebConstants.role] as! String == keyName{
                        print("name else: \(casting[cast][WebConstants.name] as! String)")
                        valuesArray.append(casting[cast][WebConstants.name] as! String)
                    }else {
                        keyName =  casting[cast][WebConstants.role] as! String
                        var tempValuesArray = dataDic[casting[cast][WebConstants.role] as! String] as! [String]
                        tempValuesArray.append(casting[cast][WebConstants.name] as! String)
                        valuesArray.removeAll()
                        valuesArray = tempValuesArray
                    }
                    
                    dataDic[keyName] = valuesArray
    //                keysArray = []
    //                keyName = ""
                }
                
                
                
                
//            let values = casting.map { $0["role"] as? String == "SINGER"
//                if !keysArray.contains($0["role"] as! String) {
//                    keyName =  $0["role"] as! String
//                    valuesArray.append($0["name"] as! String)
//                    keysArray.append($0["role"] as! String)
//                    print("name: \($0["name"] as! String)")
//                }else{
//                    print("name else: \($0["name"] as! String)")
//                    valuesArray.append($0["name"] as! String)
//                }
//
//                dataDic[keyName] = valuesArray
//                keysArray = []
//                valuesArray = []
//                keyName = ""
//            }
//            print(values)
            
//            print("keysArray: \(keysArray)")
//            print("dataDic: \(dataDic)")
            
            // casting
//                for cast in 0..<casting.count {
//                    if casting[cast][WebConstants.role] as! String == WebConstants.director {
//
//                        self.director.append(casting[cast][WebConstants.name] as! String)
//                    }
//                    else if casting[cast][WebConstants.role] as! String == WebConstants.producer {
//
//                        self.producer.append(casting[cast][WebConstants.name] as! String)
//                    }
//                    else if casting[cast][WebConstants.role] as! String == WebConstants.actor {
//
//                        self.starCast.append(casting[cast][WebConstants.name] as! String)
//                    }else if casting[cast][WebConstants.role] as! String == WebConstants.writer {
//
//                        self.writer.append(casting[cast][WebConstants.name] as! String)
//                    }else if casting[cast][WebConstants.role] as! String == WebConstants.kids {
//
//                        self.kids.append(casting[cast][WebConstants.name] as! String)
//                    }
//                }
            }
        }
    }
    
    //MARK: Set Continue list data in show model..
    func updateWithContinuelistData(_ dic: [String: Any]){
    // get content ..
        if let content = dic[WebConstants.contentId] as? [String:Any]{
            print(content)
            // get content_id
            if let id = content[WebConstants.id] as? String {
                self._id = id
            }
            // get time left
            if let timeleft = dic[WebConstants.timeleft] as? String {
                self.subscriptionTimeLeft = timeleft
            }
            // title
            if let title = content[WebConstants.title] as? String {
                self.title = title
            }
            // subtitle
            if let subtitle = content[WebConstants.subtitle] as? String {
                self.subtitle = subtitle
            }
            
            // contentThumbnail
            if let contentThumbnail = content[WebConstants.contentThumbnail] as? String {
                self.contentThumbnail = contentThumbnail
            }
            // trailerUrl
            if let trailerUrl = dic[WebConstants.trailerFile] as? String {
                self.trailerUrl = trailerUrl
            }
            //urlAsset
            if let streamUrl = dic[WebConstants.streamFile] as? String {
                self.streamUrl = streamUrl
            }
            // contentDescription
            if let contentDescription = content[WebConstants.contentDescription] as? String {
                self.contentDescription = contentDescription
            }
            
            // playDuration
            if let playDuration = content[WebConstants.playDuration] as? String {
                self.playDuration = playDuration
            }
            
            // totalplayDuration
            if let totalplayDuration = dic[WebConstants.playDuration] as? String {
                self.totalPlayDuration = totalplayDuration
            }
            
            // timeLeft
            if let timeLeft = dic[WebConstants.timeLeft] as? String {
                self.timeLeft = timeLeft
            }
            
            // payPerViewPrice
            if let payPerViewPrice = dic[WebConstants.payPerViewPrice] as? Double {
                let strPrice = "\(payPerViewPrice)"
                if strPrice.contains(".00") || strPrice.contains(".0") {
                    self.payPerViewPrice = "\(Int(payPerViewPrice))"
                } else {
                    self.payPerViewPrice = String(format: "%.2f", payPerViewPrice)
                }
            } else {
                if let payPerViewPriceDict = dic[WebConstants.contentId] as? NSDictionary {
                    if let payPerViewPrice = payPerViewPriceDict[WebConstants.payPerViewPrice] as? Double {
                        let strPrice = "\(payPerViewPrice)"
                        if strPrice.contains(".00") || strPrice.contains(".0") {
                            self.payPerViewPrice = "\(Int(payPerViewPrice))"
                        } else {
                            self.payPerViewPrice = String(format: "%.2f", payPerViewPrice)
                        }
                    }
                }
            }
            
            // buyToOwnPrice
            if let buyToOwnPrice = dic[WebConstants.buyToOwnPrice] as? Double {
                let strPrice = "\(buyToOwnPrice)"
                if strPrice.contains(".00")  || strPrice.contains(".0"){
                    self.buyToOwnPrice = "\(Int(buyToOwnPrice))"
                } else {
                    self.buyToOwnPrice = String(format: "%.2f", buyToOwnPrice)
                }
            } else {
                if let buyToOwnPriceDict = dic[WebConstants.contentId] as? NSDictionary {
                    if let buyToOwnPrice = buyToOwnPriceDict[WebConstants.buyToOwnPrice] as? Double {
                        let strPrice = "\(buyToOwnPrice)"
                        if strPrice.contains(".00") || strPrice.contains(".0") {
                            self.buyToOwnPrice = "\(Int(buyToOwnPrice))"
                        } else {
                            self.buyToOwnPrice = String(format: "%.2f", buyToOwnPrice)
                        }
                    }
                }
            }
            
            // buyToOwnStatus
            if let buyToOwnStatus = content[WebConstants.buyToOwnStatus] as? Bool {
                self.buyToOwnStatus = buyToOwnStatus
            }
            
            // buyToOwnStatus
            if let paymentType = dic[WebConstants.paymentType] as? Int {
                self.paymentType = "\(paymentType)"
            }
            
            // buyToOwnStatus
            if let payPerViewStatus = content[WebConstants.payPerViewStatus] as? Bool {
                self.payPerViewStatus = payPerViewStatus
            }
            // applause
            if let applause = content[WebConstants.applause] as? Int {
                self.applause = applause
            }
            //isDanceStudioPrivate
            if let isDanceStudioPrivate = dic[WebConstants.isDanceStudioPrivate] as? Bool {
                self.isDanceStudioPrivate = isDanceStudioPrivate
            }
            // standingOvation
            if let standingOvation = content[WebConstants.standingOvation] as? Int {
                self.standingOvation = standingOvation
            }
            
            dataDic.removeAll()

            var keysArray: [String] = []
            var valuesArray: [String] = []
            var keyName = ""
            
            if let casting = content[WebConstants.casting] as? [[String:Any]] {

                if self.subtitle != "" && self.subtitle != nil{
                    dataDic[WebConstants.showSubTitle] = self.subtitle
                }
                
                if self.contentDescription != "" && self.contentDescription != nil{
                    dataDic[WebConstants.showDesc] = self.contentDescription
                }
                
                for cast in 0..<casting.count {
                    if !keysArray.contains(casting[cast][WebConstants.role] as! String) {
                        valuesArray = []
                        keyName =  casting[cast][WebConstants.role] as! String
                        valuesArray.append(casting[cast][WebConstants.name] as! String)
                        keysArray.append(casting[cast][WebConstants.role] as! String)
                        print("name: \(casting[cast][WebConstants.name] as! String)")
                    }else if casting[cast][WebConstants.role] as! String == keyName{
                        print("name else: \(casting[cast][WebConstants.name] as! String)")
                        valuesArray.append(casting[cast][WebConstants.name] as! String)
                    }else {
                        keyName =  casting[cast][WebConstants.role] as! String
                        var tempValuesArray = dataDic[casting[cast][WebConstants.role] as! String] as! [String]
                        tempValuesArray.append(casting[cast][WebConstants.name] as! String)
                        valuesArray.removeAll()
                        valuesArray = tempValuesArray
                    }
                    
                    dataDic[keyName] = valuesArray
    //                keysArray = []
    //                keyName = ""
                }
                
                
                
                
//                let values = casting.map { $0["role"] as? String == "SINGER"
//                    if !keysArray.contains($0["role"] as! String) {
//                        keyName =  $0["role"] as! String
//                        valuesArray.append($0["name"] as! String)
//                        keysArray.append($0["role"] as! String)
//                        print("name: \($0["name"] as! String)")
//                    }else{
//                        print("name else: \($0["name"] as! String)")
//                        valuesArray.append($0["name"] as! String)
//                    }
//
//                    dataDic[keyName] = valuesArray
//                    keysArray = []
//                    valuesArray = []
//                    keyName = ""
//                }
//            print(values)
            
//            print("keysArray: \(keysArray)")
//            print("dataDic: \(dataDic)")
            
    
            // casting
//                for cast in 0..<casting.count {
//                    if casting[cast][WebConstants.role] as! String == WebConstants.director {
//
//                        self.director.append(casting[cast][WebConstants.name] as! String)
//                    }
//                    else if casting[cast][WebConstants.role] as! String == WebConstants.producer {
//
//                        self.producer.append(casting[cast][WebConstants.name] as! String)
//                    }
//                    else if casting[cast][WebConstants.role] as! String == WebConstants.actor {
//
//                        self.starCast.append(casting[cast][WebConstants.name] as! String)
//                    }else if casting[cast][WebConstants.role] as! String == WebConstants.writer {
//
//                        self.writer.append(casting[cast][WebConstants.name] as! String)
//                    }else if casting[cast][WebConstants.role] as! String == WebConstants.kids {
//
//                        self.kids.append(casting[cast][WebConstants.name] as! String)
//                    }
//                }
            }
        }
    }
}

class SequenceContentIds : NSObject {
    var _id : String?
    var contentThumbnail : String?
    var title : String?
    
    func updateWithData(_ dic: [String: Any]) {
        if let id = dic[WebConstants.id] as? String {
            self._id = id
        }
        
        // title
        if let title = dic[WebConstants.title] as? String {
            self.title = title
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
