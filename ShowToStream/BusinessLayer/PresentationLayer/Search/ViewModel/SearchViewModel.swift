//
//  SearchViewModel.swift
//  ShowToStream
//
//  Created by Applify on 05/01/21.
//  Copyright © 2020 Applify. All rights reserved.
//

import IQKeyboardManagerSwift
import SwipeCellKit
import UIKit

class SearchViewModel: BaseViewModel {
    var user = KUSERMODEL.user
    var sessionCreated: Bool = false
    var selectedCategory: PreferenceCategory?
    var selectedGenre: PreferenceGenre?
    var selecedCategoryIds = [String]()
    var selecedGenresIds = [String]()
    var group = DispatchGroup()
    var titleLabel : UILabel!
    var isCome = ""
    weak var placeholderView: UIView!
    var title: String {
        if let selectedCategory = selectedCategory {
            return selectedCategory.name
        }
        if let selectedGenre = selectedGenre {
            return selectedGenre.name
        }
        return StringConstants.search
    }
    var backButton : UIButton!
    weak var searchBar: UISearchBar! { didSet { configureSearchBar() } }
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    var categories: [PreferenceCategory] = SharedDataManager.shared.categories
    var genres: [PreferenceGenre] = SharedDataManager.shared.genres
    var topSearches: [Show] = []
    var recentSearches: [Show] = []
    var searchedString = ""
    var searchedShows: [Show] = []
    var selectedTopSearchShow : Show!
    var show : [Show] = []
    var displayRecentSearch = false
    var displayShows: Bool {
        return !searchedString.isEmpty || selectedCategory != nil || selectedGenre != nil || !(selectedTopSearchShow == nil)
    }
    
    fileprivate func updateCollectionViewInsets() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: max(keyboardHeight, 100), right: horizontalPadding)
    }
    
    fileprivate var horizontalPadding: CGFloat = 12  { didSet { updateCollectionViewInsets() } }
    var keyboardHeight: CGFloat = 0 { didSet { updateCollectionViewInsets() } }
    
    private func configureSearchBar() {
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.delegate = self
        searchBar.setImage(#imageLiteral(resourceName: "SearchIcon"), for: .search, state: .normal)
        searchBar.setImage(#imageLiteral(resourceName: "SearchClear"), for: .clear, state: .normal)

        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.appGray
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 100 + keyboardHeight, right: 12)
                
        let nib = UINib(nibName: NibCellIdentifier.baseTileCollectionViewCellNib, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.categories)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.genre)

        collectionView.register(UINib(nibName: StringConstants.topSearchCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.topSearch)
        
        collectionView.register(UINib(nibName: StringConstants.recentSearchCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.recentSearch)
        
        collectionView.register(UINib(nibName: StringConstants.searchedShowCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.searchedShow)

        collectionView.register(UINib(nibName: NibCellIdentifier.baseHeaderCollectionReusableViewNib, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionViewCellIdentifier.searchHeader)
    }
    
    func backButtonTapped(){
        searchBar.resignFirstResponder()
        selectedTopSearchShow = nil
        selecedCategoryIds = [String]()
        selecedGenresIds = [String]()
        selectedCategory = nil
        selectedGenre = nil
        recentSearches.removeAll()
        searchedString = ""
        searchedShows.removeAll()
        
        titleLabel.text = title
        searchBar.text = ""
        
        DispatchQueue.main.async {
            self.displayRecentSearch = false
            self.collectionView.reloadData()
            self.loadData()
        }
        
        
    }
    
    func showBackButton(){
        if displayShows{
            backButton.isHidden = false
        }else{
            backButton.isHidden = true
        }
    }
    
    func loadData(){
        placeholderView.isHidden = true
        showBackButton()
        
        recentSearches.removeAll()
        // to check for selected items...
        if selectedCategory != nil {
            getSelectedCategorySearchData()
        } else if selectedGenre != nil {
            getSelectedGenresSearchData()
        } else if selectedTopSearchShow != nil{
            getSelectedTopSearchData(searchText: selectedTopSearchShow.keyword ?? "")
        } else{
            group.enter()
            processDataForTopTenSearchData()
            
            //check for user session ...
            if sessionCreated {
               group.enter()
                processDataForGetRecentSearchData()
            }

            group.notify(queue: .main) {
                // whatever you want to do when both are done
                if self.collectionView != nil { self.collectionView.reloadData() }
            }
        }
        
    }
    
    // used for get category search list..
    private func getSelectedCategorySearchData(){
        selecedCategoryIds = [String]()
        selecedCategoryIds.append(selectedCategory!._id)
        let params: [String: Any] = [WebConstants.categoryIds: selecedCategoryIds]
        processDataForSearchData(params: params)
    }
    // used for get genres search list...
    private func getSelectedGenresSearchData(){
        selecedGenresIds = [String]()
        selecedGenresIds.append(selectedGenre!._id)
        let params: [String: Any] = [WebConstants.genreIds: selecedGenresIds]
        self.processDataForSearchData(params: params)
    }
    
    // used for get selected top search search list...
    private func getSelectedTopSearchData(searchText: String){
        selecedGenresIds = [String]()
        selecedCategoryIds = [String]()
        let params: [String: Any] = [WebConstants.title: searchText]
        self.processDataForSearchData(params: params)
    }
    
    // used for get category search..
    private func getSelectedCategorySearchTextData(){
        selecedCategoryIds = [String]()
        selecedCategoryIds.append(selectedCategory!._id)
        let params: [String: Any] = [WebConstants.categoryIds: selecedCategoryIds,
                                     WebConstants.title: searchedString]
        self.processDataForSearchData(params: params)
    }
    // used for get genres search...
    private func getSelectedGenresSearchTextData(){
        selecedGenresIds = [String]()
        selecedGenresIds.append(selectedGenre!._id)
        let params: [String: Any] = [WebConstants.genreIds: selecedGenresIds,
                                     WebConstants.title: searchedString]
        self.processDataForSearchData(params: params)
    }
   
    // used for get genres search...
    func getSearchTextData(){
        displayRecentSearch = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        let params: [String: Any] = [WebConstants.title: searchedString]
        self.processDataForSearchData(params: params)
    }
    
    func processDataForSearchData(params: [String: Any]) {
        showLoader()
        if KUSERMODEL.isLoggedIn() {
            let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
            ApiManager.makeApiCall(APIUrl.Content.searchV1,
                                   params: params,
                                   headers: headers,
                                   method: .post) { response, _ in
                if !self.hasErrorIn(response) {
                    let responseData = response![APIConstants.data] as! [[String:Any]]
                    var showList = [Show]()
                    self.searchedShows = [Show]()
                    for rawObject in responseData {
                        let show = Show()
                        show.updateWithHomeData(rawObject )
                        showList.append(show)
                    }
                    self.searchedShows.append(contentsOf: showList)
                    
                    if self.searchedShows.count != 0 {
                        self.placeholderView.isHidden = true
                    }else{
                        self.placeholderView.isHidden = false
                    }
                    self.collectionView.reloadData()
                }
                hideLoader()
            }
        } else {
            let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
            ApiManager.makeApiCall(APIUrl.Content.search,
                                   params: params,
                                   headers: headers,
                                   method: .post) { response, _ in
                if !self.hasErrorIn(response) {
                    let responseData = response![APIConstants.data] as! [[String:Any]]
                    var showList = [Show]()
                    self.searchedShows = [Show]()
                    for rawObject in responseData {
                        let show = Show()
                        show.updateWithHomeData(rawObject )
                        showList.append(show)
                    }
                    self.searchedShows.append(contentsOf: showList)
                    
                    if self.searchedShows.count != 0 {
                        self.placeholderView.isHidden = true
                    }else{
                        self.placeholderView.isHidden = false
                    }
                    self.collectionView.reloadData()
                }
                hideLoader()
            }
        }
        
    }
    
    private func processDataForTopTenSearchData() {
        ApiManager.makeApiCall(APIUrl.HomeCommon.topTenSearch,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.topSearches = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject )
                                        showList.append(show)
                                    }
                                    self.topSearches.append(contentsOf: showList)
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    private func processDataForGetRecentSearchData() {
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.searchKeyword,
                               headers: headers,
                               method: .get) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.recentSearches = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject )
                                        showList.append(show)
                                    }
                                    self.recentSearches.append(contentsOf: showList)
                                    self.group.leave()
                                }
                                hideLoader()
        }
    }
    
    func processDataForLoginPostSearchText(params:[String:Any]) {
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.searchKeyword,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                   // let responseData = response![APIConstants.data] as! [[String:Any]]
                                    
                                }
                                hideLoader()
        }
    }
    
    func processDataForGuestPostSearchText(params:[String:Any]) {
        ApiManager.makeApiCall(APIUrl.HomeCommon.searchKeyword,
                               params: params,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                  //  let responseData = response![APIConstants.data] as! [[String:Any]]
                                    
                                }
                                hideLoader()
        }
    }

}

extension SearchViewModel: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.superview?.layer.borderColor = UIColor.appVoilet.cgColor
        if self.sessionCreated {
            displayRecentSearch = true
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.superview?.layer.borderColor = UIColor.appSearchBorder.cgColor
      
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // to check for selected items...
        if searchedString != ""{
            if selectedCategory != nil {
                getSelectedCategorySearchTextData()
            } else if selectedGenre != nil {
                getSelectedGenresSearchTextData()
            } else {
                getSearchTextData()
                postSearchKeyword()
            }
            
            displayRecentSearch = false
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func postSearchKeyword(){
        let params: [String: Any] = [WebConstants.keyword: searchBar.text!]
        if self.sessionCreated {
            self.processDataForLoginPostSearchText(params: params)
        }else{
            self.processDataForGuestPostSearchText(params:params)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedString = searchText.trimmed
        if searchedString == ""{
            DispatchQueue.main.async {
                self.displayRecentSearch = false
                self.collectionView.reloadData()
                self.loadData()
            }
        }else{
            DispatchQueue.main.async {
                self.displayRecentSearch = false
                self.collectionView.reloadData()
            }
        }
//        if displayShows {
//            horizontalPadding = 0
//        } else {
//            horizontalPadding = 12
//        }
    }
}


