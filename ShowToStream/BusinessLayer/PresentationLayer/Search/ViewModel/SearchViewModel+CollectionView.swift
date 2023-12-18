//
//  SearchViewModel+CollectionView.swift
//  ShowToStream
//
//  Created by 1312 on 05/01/21.
//

import UIKit

extension SearchViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if displayRecentSearch {
            return 1
        }else{
            if searchedShows.count != 0{
                return 4
            }else{
                return 3
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if displayRecentSearch {
            return recentSearches.count
        }else{
            switch section {
            case 0:
                return displayShows ? 0 : categories.count
            case 1:
                return displayShows ? 0 : genres.count
            case 2:
                return displayShows ? 0 : topSearches.count
            case 3:
                return searchedShows.count
            default:
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if displayRecentSearch {
            let lineHeight: CGFloat = 30
            var font = UIFont()
            if UIDevice.current.userInterfaceIdiom == .pad{
                font = UIFont.appSemiBoldFont(with: 22)
            }else{
                font = UIFont.appSemiBoldFont(with: 14)
            }
            
            return BaseHeaderCollectionReusableView.sizeWith(title: "",
                                                             font: font,
                                                             maxWidth: collectionView.frame.size.width - 30,
                                                             lineHeight: lineHeight)
        }else{
            if displayShows {
                return .zero
            }
            var string = ""
            var lineHeight: CGFloat = 20
            var font = UIFont()
            if UIDevice.current.userInterfaceIdiom == .pad{
                font = UIFont.appSemiBoldFont(with: 22)
            }else{
                font = UIFont.appSemiBoldFont(with: 14)
            }
            switch section {
            case 0:
                string = StringConstants.exploreByCategory
            case 1:
                string = StringConstants.exploreByGenre
            case 2:
                string = StringConstants.topSearches
                lineHeight = 30
            default:
                return .zero
            }
        
        return BaseHeaderCollectionReusableView.sizeWith(title: string,
                                                         font: font,
                                                         maxWidth: collectionView.frame.size.width - 30,
                                                         lineHeight: lineHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: CollectionViewCellIdentifier.searchHeader,
                                                                   for: indexPath) as! BaseHeaderCollectionReusableView
        view.lineHeight = 20
        
        if displayRecentSearch {
            view.title = StringConstants.recentSearch
            view.lineHeight = 20
        }else{
            
            switch indexPath.section {
            case 0:
                view.title = StringConstants.exploreByCategory
            case 1:
                view.title = StringConstants.exploreByGenre
            case 2:
                view.title = StringConstants.topSearches
                view.lineHeight = 30
            default:
                break
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad{
            view.titleFont = UIFont.appSemiBoldFont(with: 22)
        }else{
            view.titleFont = UIFont.appSemiBoldFont(with: 14)
        }
        
        view.titleColor = .appGray
        view.titleLeftPadding = 0

        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if displayRecentSearch {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.recentSearch,
                                                          for: indexPath) as! RecentSearchCollectionViewCell
            
            cell.recentSearch = recentSearches[indexPath.item].keyword ?? ""
            return cell
        }else{
            if indexPath.section == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.topSearch,
                                                              for: indexPath) as! TopSearchCollectionViewCell
                
                cell.topSearch = topSearches[indexPath.item].keyword ?? ""
                return cell
            } else if indexPath.section == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.searchedShow,
                                                              for: indexPath) as! SearchedShowCollectionViewCell
                
                cell.show = searchedShows[indexPath.item]
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.categories,
                                                          for: indexPath) as! BaseTileCollectionViewCell
            if indexPath.section == 0 {
                configureCategoryCell(cell: cell, indexPath: indexPath)
            } else if indexPath.section == 1 {
                configureGenreCell(cell: cell, indexPath: indexPath)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if displayRecentSearch {
            searchedString = recentSearches[indexPath.item].keyword ?? ""
            searchBar.text = searchedString
            getSearchTextData()
            
        }else{
            if indexPath.section == 0 {
                selectedCategory = categories[indexPath.item]
                titleLabel.text = title
                loadData()
            }
            else if indexPath.section == 1 {
                selectedGenre = genres[indexPath.item]
                titleLabel.text = title
                loadData()
            }
            else if indexPath.section == 2 {
                selectedTopSearchShow = topSearches[indexPath.item]
                searchBar.text = topSearches[indexPath.item].keyword
                loadData()
            }
            else if indexPath.section == 3 {
                ShowDetailViewController.show(from: self.hostViewController, show: searchedShows[indexPath.item], isCome: "", universal_showId: "")
            }
        }
    }
    
    private func configureCategoryCell(cell: BaseTileCollectionViewCell,
                                       indexPath: IndexPath) {
        let category                    = categories[indexPath.item]
        cell.title                      = category.name
//        cell.image                      = category.image
        cell.imageUrl                   = category.image
        
        cell.defaultTileColor           = .white
        cell.selectedTileColor          = .white
        cell.defaultCornerRadius        = 8
        cell.selectedCornerRadius       = 8
        cell.defaultBorderWidth         = 0
        cell.selectedBorderWidth        = 0
        cell.defaultBorderColor         = .appLightBlack
        cell.selectedBorderColor        = .appVoiletBackground
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
        cell.defaultBackgroundColor     = .clear
        cell.selectedBackgroundColor    = .clear
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            cell.titleFont                  = .appRegularFont(with: 22)
            cell.selectedTitleFont          = .appBoldFont(with: 22)
        }else{
            cell.titleFont                  = .appRegularFont(with: 14)
            cell.selectedTitleFont          = .appBoldFont(with: 14)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if displayRecentSearch {
            let width = collectionView.frame.size.width - 30
            return CGSize(width: width, height: 40)
        }else{
            if indexPath.section == 0 {
                let width = (collectionView.frame.size.width / 2) - 14
                return CGSize(width: width, height: width / 2.56)
            } else if indexPath.section == 1 {
                let genre = genres[indexPath.item].name
                var size = CGSize()
                
                if UIDevice.current.userInterfaceIdiom == .pad{
                    let width = genre.width(with: UIFont.appRegularFont(with: 18.0),
                                        padding: 28,
                                        maxWidth: collectionView.frame.size.width - 30)
                    size = CGSize(width: width, height: 41)
                }else {
                    let width = genre.width(with: UIFont.appRegularFont(with: 14.0),
                                        padding: 28,
                                        maxWidth: collectionView.frame.size.width - 30)
                    size = CGSize(width: width, height: 41)
                }
                
                return size
            } else if indexPath.section == 2 {
                let width = collectionView.frame.size.width - 30
                return CGSize(width: width, height: 40)
            } else if indexPath.section == 3 {
                if UIDevice.current.userInterfaceIdiom == .pad{
                    return CGSize(width: collectionView.frame.size.width, height: 152)
                }else{
                    return CGSize(width: collectionView.frame.size.width, height: 122)
                }
            }
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 6
        } else if section == 1 {
            return 16
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 12
        }
        return 0
    }
}
