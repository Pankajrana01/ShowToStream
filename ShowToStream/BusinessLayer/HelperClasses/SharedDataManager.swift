//
//  SharedDataManager.swift
//  ShowToStream
//
//  Created by 1312 on 12/01/21.
//

import UIKit

extension Notification.Name {
    static let preferenceDataUpdated    = Notification.Name("preferenceDataUpdated")
}

fileprivate class GenresResponse: GeneralAPiResponse {
    var data: [PreferenceGenre] = []
    
    private enum CodingKeys: String, CodingKey { case data }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(type(of: data).self, forKey: .data)
        try super.init(from: decoder)
    }
}

fileprivate class CategoriesResponse: GeneralAPiResponse {
    var data: [PreferenceCategory] = []
    
    private enum CodingKeys: String, CodingKey { case data }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode( type(of: data).self, forKey: .data)
        try super.init(from: decoder)
    }
}

class SharedDataManager {
    
    static let shared: SharedDataManager = SharedDataManager()
    
    var hasLoadedPreferenceData: Bool = false
    var categories: [PreferenceCategory] = []
    var genres: [PreferenceGenre] = []

    // by default set to true. Will be set to false when refresh data call successfully returns the data
    var shouldRefreshedData: Bool = true
    var isRefreshingData: Bool = false
    
    func initialize() {
        loadPreferenceData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStatusUpdated),
                                               name: .networkStatusUpdated,
                                               object: nil)
    }
    
    private init() {

    }
    
    @objc
    private func networkStatusUpdated() {
        loadPreferenceData()
    }
    
    func loadPreferenceData(silentLoad: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard shouldRefreshedData, !isRefreshingData else {
            completionHandler?()
            return
        }
        isRefreshingData = true
        
        if !silentLoad {
            showLoader()
        }
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        loadCategories {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        loadGenres {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if !silentLoad {
                hideLoader()
            }
            if !self.categories.isEmpty, !self.genres.isEmpty {
                self.hasLoadedPreferenceData = true
                self.shouldRefreshedData = false
                NotificationCenter.default.post(name: .preferenceDataUpdated, object: nil)
            }
            self.isRefreshingData = false
            completionHandler?()
        }

    }
}

extension SharedDataManager {
    fileprivate func loadCategories(_ completionHandler: @escaping () -> Void) {
        ApiManager.makeApiCall(APIUrl.Preference.categories, method: .get) { response, data in
            if !BaseViewModel.hasErrorIn(response),
               let data = data {
                let decoder = JSONDecoder()
                do {
                    let categoriesResponse = try decoder.decode(CategoriesResponse.self, from: data)
                    self.categories = categoriesResponse.data
                } catch {
                    print(error.localizedDescription)
                }
            }
            completionHandler()
        }
    }
    
    fileprivate func loadGenres(_ completionHandler: @escaping () -> Void) {
        ApiManager.makeApiCall(APIUrl.Preference.genres, method: .get) { response, data in
            if !BaseViewModel.hasErrorIn(response),
               let data = data {
                let decoder = JSONDecoder()
                do {
                    let genresResponse = try decoder.decode(GenresResponse.self, from: data)
                    self.genres = genresResponse.data
                } catch {
                    print(error.localizedDescription)
                }
            }
            completionHandler()
        }
    }
    
    func multiple(lhs: Double, rhs: Double) -> Double {
        return Double(lhs) * rhs
    }
}


extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
