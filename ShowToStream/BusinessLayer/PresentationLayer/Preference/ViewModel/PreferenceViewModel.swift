//
//  PreferenceViewModel.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit

class PreferenceViewModel: BaseViewModel {
    var isForCreateNewProfile: Bool = false
    var preferencesSetNavigationBlock: (() -> Void)?
    var profile: Profile?
    private var categories: [PreferenceCategory] = SharedDataManager.shared.categories
    private var genres: [PreferenceGenre] = SharedDataManager.shared.genres
    
    private var selectedCategoriesIndex: [Int] = []
    private var selectedGenresIndex: [Int] = []
    
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    
    private func configureCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: NibCellIdentifier.baseTileCollectionViewCellNib, bundle: nil)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.categories)
        collectionView.register(nib,
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.genre)
        collectionView.register(UINib(nibName: NibCellIdentifier.baseHeaderCollectionReusableViewNib, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionViewCellIdentifier.preferenceHeader)
        populateData()
    }
    
    override func viewLoaded() {
        super.viewLoaded()
        if !SharedDataManager.shared.hasLoadedPreferenceData {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(preferenceDataUpdated),
                                                   name: .preferenceDataUpdated,
                                                   object: nil)
        }
    }
    
    fileprivate func populateData() {
        categories = SharedDataManager.shared.categories
        genres = SharedDataManager.shared.genres

        let selectedCategories: [PreferenceCategory]
        
        if !isForCreateNewProfile {
            if let profile = profile {
                selectedCategories = profile.categories
            } else {
                selectedCategories = AppStorage.shared.categories
            }
            selectedCategories.forEach( { selectedCategory in
                if let index =  categories.firstIndex(where: { $0 == selectedCategory} ) { selectedCategoriesIndex.append(index) }
            })
        }
      
        
//        "_id" = 600ebdfe25f41672f0ab466a;
//        categoryIds =             (
//            6010e7a825f41672f0ab4689
//        );
//        genreIds =             (
//            5ffd4718565ce21b0f7b9da6,
//            5ffd473b565ce21b0f7b9daa
//        );
        
        let selectedGenres: [PreferenceGenre]
        
        if !isForCreateNewProfile {
            if let profile = profile {
                selectedGenres = profile.genres
            } else {
                selectedGenres = AppStorage.shared.genres
            }
            selectedGenres.forEach( { selectedGenre in
                if let index =  genres.firstIndex(where: { $0 == selectedGenre} ) { selectedGenresIndex.append(index) }
            })
        }
        
        collectionView?.reloadData()
    }
    
    fileprivate func preferencesSaved() {
        if let block = preferencesSetNavigationBlock {
            block()
        } else {
            self.hostViewController.backButtonTapped(nil)
        }
    }
    
    @objc
    private func preferenceDataUpdated() {
        NotificationCenter.default.removeObserver(self)
        populateData()
    }
    
    func confirmButtonTapped() {
        if self.validateModel() {
            if let profile = profile {
                var selecedCategoryIds = [String]()
                selectedCategoriesIndex.forEach( { selecedCategoryIds.append(categories[$0]._id) } )

                var selecedGenreIds = [String]()
                selectedGenresIndex.forEach( { selecedGenreIds.append(genres[$0]._id) } )
                let params: [String: Any] = [WebConstants.categoryIds: selecedCategoryIds,
                                             WebConstants.genreIds: selecedGenreIds,
                                             WebConstants.profileId: profile._id!]
                processData(params: params)
            } else {
                savePreferenceLocally()
                let controller = LandingViewController.getController()
                controller.clearNavigationStackOnAppear = true
                controller.show(from: self.hostViewController)
            }
        }
    }
    
    func skipButtonTapped(){
        
        for index in 0..<categories.count{
            selectedCategoriesIndex.append(index)
        }
        for index in 0..<genres.count{
            selectedGenresIndex.append(index)
        }
        
        savePreferenceLocally()
        let controller = LandingViewController.getController()
        controller.clearNavigationStackOnAppear = true
        controller.show(from: self.hostViewController)
    }
}

extension PreferenceViewModel {
    func processData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.preferences,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let rawProfiles = response![APIConstants.data] as! [[String: Any]]
                                    KUSERMODEL.updateProfiles(rawProfiles)
                                    self.preferencesSaved()
                                }
                                hideLoader()
        }
    }
}

extension PreferenceViewModel {
    // call this method to save the preferences locally
    fileprivate func savePreferenceLocally() {
        var selecedCategories = [PreferenceCategory]()
        selectedCategoriesIndex.forEach( { selecedCategories.append(categories[$0]) } )

        var selecedGenres = [PreferenceGenre]()
        selectedGenresIndex.forEach( { selecedGenres.append(genres[$0]) } )

        AppStorage.shared.categories = selecedCategories
        AppStorage.shared.genres = selecedGenres
        AppStorage.shared.hasSetPreferences = true
    }
}

extension PreferenceViewModel {
    func validateModel() -> Bool {
        if selectedCategoriesIndex.isEmpty {
            showMessage(with: ValidationError.emptyCategories)
            return false
        }
        if selectedGenresIndex.isEmpty {
            showMessage(with: ValidationError.emptyGenre)
            return false
        }
        return true
    }
}

extension PreferenceViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return categories.count
        case 2:
            return genres.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        var string = ""
        var font = UIFont()
        if UIDevice.current.userInterfaceIdiom == .pad{
            font = UIFont.appLightFont(with: 36)
        }else{
            font = UIFont.appLightFont(with: 32)
        }
        switch section {
        case 0:
            string = StringConstants.preferenceTitle
        case 1:
            if categories.isEmpty {
                return .zero
            }
            string = StringConstants.categoriesTitle
            if UIDevice.current.userInterfaceIdiom == .pad{
                font = UIFont.appLightFont(with: 22)
            }else{
                font = UIFont.appLightFont(with: 14)
            }
        case 2:
            if genres.isEmpty {
                return .zero
            }
            string = StringConstants.genreTitle
            if UIDevice.current.userInterfaceIdiom == .pad{
                font = UIFont.appLightFont(with: 22)
            }else{
                font = UIFont.appLightFont(with: 14)
            }
            
        default:
            return .zero
        }
        return BaseHeaderCollectionReusableView.sizeWith(title: string,
                                                         font: font,
                                                         maxWidth: collectionView.frame.size.width - 30,
                                                         lineHeight: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: CollectionViewCellIdentifier.preferenceHeader,
                                                                   for: indexPath) as! BaseHeaderCollectionReusableView
        switch indexPath.section {
        case 0:
            view.title = StringConstants.preferenceTitle
            if UIDevice.current.userInterfaceIdiom == .pad{
                view.titleFont = UIFont.appLightFont(with: 36)
            }else{
                view.titleFont = UIFont.appLightFont(with: 32)
            }
            view.titleColor = .white
        case 1:
            view.title = StringConstants.categoriesTitle
            if UIDevice.current.userInterfaceIdiom == .pad{
                view.titleFont = UIFont.appSemiBoldFont(with: 22)
            }else{
                view.titleFont = UIFont.appSemiBoldFont(with: 14)
            }
            view.titleColor = .appGray
        case 2:
            view.title = StringConstants.genreTitle
            if UIDevice.current.userInterfaceIdiom == .pad{
                view.titleFont = UIFont.appSemiBoldFont(with: 22)
            }else{
                view.titleFont = UIFont.appSemiBoldFont(with: 14)
            }
            view.titleColor = .appGray
        default:
            break
        }

        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.categories,
                                                      for: indexPath) as! BaseTileCollectionViewCell
        if indexPath.section == 1 {
            configureCategoryCell(cell: cell, indexPath: indexPath)
        } else {
            configureGenreCell(cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let index = selectedCategoriesIndex.firstIndex(where: { index -> Bool in
                index == indexPath.item
            }) {
                selectedCategoriesIndex.remove(at: index)
            } else {
                selectedCategoriesIndex.append(indexPath.item)
            }
        } else if indexPath.section == 2 {
            if let index = selectedGenresIndex.firstIndex(where: { index -> Bool in
                index == indexPath.item
            }) {
                selectedGenresIndex.remove(at: index)
            } else {
                selectedGenresIndex.append(indexPath.item)
            }
        }
        UIView.performWithoutAnimation {
            collectionView.reloadSections(IndexSet(arrayLiteral: indexPath.section))
        }
    }
    
    private func configureCategoryCell(cell: BaseTileCollectionViewCell,
                                       indexPath: IndexPath) {
        let category                    = categories[indexPath.item]
        cell.title                      = category.name
        cell.imageUrl                   = category.image
        cell.defaultTileColor           = .white
        cell.selectedTileColor          = .white
        cell.defaultCornerRadius        = 8
        cell.selectedCornerRadius       = 8
        cell.defaultBorderWidth         = 3
        cell.selectedBorderWidth        = 3
        cell.defaultBorderColor         = .appLightBlack
        cell.selectedBorderColor        = .appVoiletBackground
        cell.tileSelected               = selectedCategoriesIndex.contains(indexPath.item)
        if UIDevice.current.userInterfaceIdiom == .pad{
            cell.titleFont                  = .appBoldFont(with: 22)
            cell.selectedTitleFont          = .appBoldFont(with: 22)
        }else{
            cell.titleFont                  = .appBoldFont(with: 14)
            cell.selectedTitleFont          = .appBoldFont(with: 14)
        }
    }

    private func configureGenreCell(cell: BaseTileCollectionViewCell,
                                    indexPath: IndexPath) {
        let genre                       = genres[indexPath.item]
        cell.title                      = genre.name
        cell.image                      = nil
        cell.imageUrl                   = ""
        cell.defaultTileColor           = .appOffWhite
        cell.selectedTileColor          = .white
        cell.defaultCornerRadius        = 6
        cell.selectedCornerRadius       = 6
        cell.defaultBorderWidth         = 1
        cell.selectedBorderWidth        = 1
        cell.defaultBorderColor         = .appGray
        cell.selectedBorderColor        = .appVoiletBackground
        cell.defaultBackgroundColor     = .appLightBlack
        cell.selectedBackgroundColor    = .appVoiletBackground
        cell.tileSelected               = selectedGenresIndex.contains(indexPath.item)
        if UIDevice.current.userInterfaceIdiom == .pad{
            cell.titleFont                  = .appRegularFont(with: 22)
            cell.selectedTitleFont          = .appBoldFont(with: 22)
        }else{
            cell.titleFont                  = .appRegularFont(with: 14)
            cell.selectedTitleFont          = .appBoldFont(with: 14)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionvayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            let width = (collectionView.frame.size.width / 2) - 14
            return CGSize(width: width, height: width / 2.56)
        } else if indexPath.section == 2 {
            let genre = genres[indexPath.item].name
            var size = CGSize()
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                let width = genre.width(with: UIFont.appRegularFont(with: 22.0),
                                        padding: 28,
                                        maxWidth: collectionView.frame.size.width - 30)
                size = CGSize(width: width, height: 41)
            }else{
                let width = genre.width(with: UIFont.appRegularFont(with: 14.0),
                                        padding: 28,
                                        maxWidth: collectionView.frame.size.width - 30)
                size = CGSize(width: width, height: 41)
            }
            
            return size
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            return 6
        } else if section == 2 {
            return 16
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            return 3
        } else if section == 2 {
            return 12
        }
        return 0
    }
}
