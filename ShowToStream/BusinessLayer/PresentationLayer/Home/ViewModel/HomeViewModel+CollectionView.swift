//
//  HomeViewModel+CollectionView.swift
//  ShowToStream
//
//  Created by Applify on 16/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import UIKit
extension HomeViewModel {
    var numberOfSections: Int {
        // top banner, continue watching, recommended for you, # 1 section per selected category in preference #, top 10, popular now, categories
        var count = 6
        //  add 1 section per selected category in preference into the 'count'.
        count += selectedCategories.count
        
        return count
    }

    func numberOfItemsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return topBannerItems.isEmpty ? 0 : 1
        case 1:
            if continueWatching.count > 2 {
                return 4
            }else{
                return continueWatching.count
            }
        case 2:
            return recommendedForYou.count
        case numberOfSections - 3:
            return top10.count
        case numberOfSections - 2:
            return popularNow.count
        case numberOfSections - 1:
            if topBannerItems.isEmpty && recommendedForYou.isEmpty && top10.isEmpty && popularNow.isEmpty && selectedCategories.isEmpty {
                return 0
            }else{
                return categories.count
            }
        default:
            let selectedCategorySectionIndex = section - 3
            if selectedCategories[selectedCategorySectionIndex].show.count > 2{
                return 4
            }else{
                return selectedCategories[selectedCategorySectionIndex].show.count
            }
        }
    }
    
    func configureHeaderView(view: BaseHeaderCollectionReusableView, forSection section: Int) {
        view.rightButtonTitle = ""
        view.rightButtonAction = nil

        switch section {
        case 1:
            view.title = StringConstants.continueWatching
            if UIDevice.current.userInterfaceIdiom == .pad{
                view.titleFont = UIFont.appSemiBoldFont(with: 22)
            }else{
                view.titleFont = UIFont.appSemiBoldFont(with: 14)
            }
          //  view.rightButtonTitle = StringConstants.viewMore
//            view.rightButtonAction = {
//                showWorkInProgress()
//            }
        case 2:
            view.title = StringConstants.recommendedForYou
            if UIDevice.current.userInterfaceIdiom == .pad{
                view.titleFont = UIFont.appRegularFont(with: 26)
            }else{
                view.titleFont = UIFont.appRegularFont(with: 18)
            }
        case numberOfSections - 3:
            view.title = StringConstants.topRated
            if UIDevice.current.userInterfaceIdiom == .pad{
                view.titleFont = UIFont.appSemiBoldFont(with: 22)
            }else{
                view.titleFont = UIFont.appSemiBoldFont(with: 14)
            }
        case numberOfSections - 2:
            view.title = StringConstants.popularNow
            if UIDevice.current.userInterfaceIdiom == .pad{
                view.titleFont = UIFont.appSemiBoldFont(with: 22)
            }else{
                view.titleFont = UIFont.appSemiBoldFont(with: 14)
            }
        case numberOfSections - 1:
            view.title = StringConstants.categories
            if UIDevice.current.userInterfaceIdiom == .pad{
                view.titleFont = UIFont.appSemiBoldFont(with: 22)
            }else{
                view.titleFont = UIFont.appSemiBoldFont(with: 14)
            }
        default:
            let selectedCategorySectionIndex = section - 3
            view.title = selectedCategories[selectedCategorySectionIndex].title
            if UIDevice.current.userInterfaceIdiom == .pad{
                view.titleFont = UIFont.appSemiBoldFont(with: 22)
            }else{
                view.titleFont = UIFont.appSemiBoldFont(with: 14)
            }
        }
        view.titleColor = .white
        view.titleLeftPadding = 0
    }
}


extension HomeViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 54)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: CollectionViewCellIdentifier.homeHeader,
                                                                   for: indexPath) as! BaseHeaderCollectionReusableView
        configureHeaderView(view: view, forSection: indexPath.section)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return getHomeBannerShowCell(with: indexPath, shows: topBannerItems)
            
        case 1:
            if indexPath.item > 2{
                return getViewMoreCell(with: indexPath, viewMore: WebConstants.continueWatching)
            }else{
                return getContinueWatchingShowCell(with: indexPath, show: continueWatching[indexPath.item])
            }
            
        case 2:
            return getHomeShowCell(with: indexPath, show: recommendedForYou[indexPath.item])
            
        case numberOfSections - 3:
            return getHomeShowCell(with: indexPath, show: top10[indexPath.item])
            
        case numberOfSections - 2:
            return getHomeShowCell(with: indexPath, show: popularNow[indexPath.item])
            
        case numberOfSections - 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.categories,
                                                          for: indexPath) as! BaseTileCollectionViewCell
            configureCategoryCell(cell: cell, indexPath: indexPath)
            return cell
        default:
            let selectedCategorySectionIndex = indexPath.section - 3
            let items = selectedCategories[selectedCategorySectionIndex].show
            
            if indexPath.item > 2{
                return getViewMoreCell(with: indexPath, viewMore: WebConstants.concert)
            }else{
                let width = (collectionView.frame.size.width / 3) - 14
                return getHomeShowCell(with: indexPath, show: items[indexPath.item], cellCornerRadius: width / 2)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? TrailerPlayerInCollectionViewCell {
            cell.stopPlayingTrailer()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        var show: Show
        switch indexPath.section {
        case 0:
            return // nothing to do on tap
        
        case 1:
            if indexPath.item > 2{
                proceedForWatchlistScreen()
                return
            }else{
                show = continueWatching[indexPath.item]
            }
            
        case 2:
            show = recommendedForYou[indexPath.item]
            
        case numberOfSections - 3:
            show = top10[indexPath.item]
            
        case numberOfSections - 2:
            show = popularNow[indexPath.item]
            
        case numberOfSections - 1:
            let categoryId = categories[indexPath.item]._id
            let categoryName = categories[indexPath.item].name
            self.proceedForSelectedCategoryScreen(id: categoryId, name: categoryName)
            return
            
        default:
            let selectedCategorySectionIndex = indexPath.section - 3
            let items = selectedCategories[selectedCategorySectionIndex].show
            
            if indexPath.item > 2{
                let categoryId = items.first!.categoryId!
                let categoryName = items.first!.categoryName!
                self.proceedForSelectedCategoryScreen(id: categoryId, name: categoryName)
                return
            }else{
                show = items[indexPath.item]
            }
        }
//        if let tabBar = (KAPPDELEGATE.window?.rootViewController as? UINavigationController)?.topViewController as? UITabBarController {
//            ShowDetailViewController.show(from: tabBar, show: show)
//        }
        
        ShowDetailViewController.show(from: self.hostViewController, show: show, isCome: "", universal_showId: "")
    }
    
    private func proceedForSelectedCategoryScreen(id:String, name:String){
        WatchlistViewController.show(from: self.hostViewController, selectedCategoryId: id, title: name)
    }
    
    private func proceedForWatchlistScreen(){
        WatchlistViewController.show(from: self.hostViewController,forcePresent: false, title: WebConstants.continueWatching, comeFrom: WebConstants.continueWatching)
    }
    
    private func getHomeShowCell(with indexPath: IndexPath, show: Show, cellCornerRadius: CGFloat = 4) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.homeShow,
                                                      for: indexPath) as! HomeShowCollectionViewCell
        cell.show = show
        cell.containerCornerRadius = cellCornerRadius
        return cell
    }
    
    private func getContinueWatchingShowCell(with indexPath: IndexPath, show: Show) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.continueWatchingShow,
                                                      for: indexPath) as! ContinueWatchingShowCollectionViewCell
        cell.timeLabel.tag = indexPath.item
        cell.show = show
        
        if show.timeLeft != "" {
            validateTimer()
            self.configureCell(with: cell, timerArray: self.timerArray, indexPath: indexPath)
        }
        return cell
    }
    
    // MARK:- Timer
    func validateTimer() {
        self.refreshTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.reloadCells), userInfo: nil, repeats: true)
        RunLoop.current.add(self.refreshTimer, forMode: RunLoop.Mode.common)
    }
    
    @objc func reloadCells() {
        let visibleCells = self.collectionView.visibleCells
        for cell in visibleCells {
            if let CollectionCell = cell as? ContinueWatchingShowCollectionViewCell {
                let indexPath = self.collectionView.indexPath(for: CollectionCell)
                if ((indexPath?.row)! < self.timerArray.count) {
                    self.configureCell(with: CollectionCell, timerArray: self.timerArray, indexPath: indexPath!)
                }
            }
        }
    }
    
    // MARK:- Configure Cell
    func configureCell(with cell:UICollectionViewCell, timerArray:[Date], indexPath:IndexPath) {
        guard let Cell = cell as? ContinueWatchingShowCollectionViewCell, timerArray.count > 0  else {
            return
        }
        let interval = Int((timerArray[indexPath.row] as AnyObject).timeIntervalSince(Date()))
        if (interval <= 0) {
            Cell.timeLabel.text = "00:00:00"
            //self.group.enter()
            //self.processDataForLoginContinueList()
        } else {
            Cell.timeLabel.text = self.getDateStringFromInterval(with: interval)
        }
    }
    
    private func getDateStringFromInterval(with interval:Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        let formattedString = formatter.string(from: TimeInterval(interval))!
        return formattedString
    }
    
    private func getViewMoreCell(with indexPath: IndexPath, viewMore:String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.viewMore,
                                                      for: indexPath) as! ViewMoreCollectionViewCell
        if viewMore == WebConstants.concert{
            cell.viewMoreViewConcert.isHidden = false
            cell.viewMoreView.isHidden = true
        }else{
            cell.viewMoreViewConcert.isHidden = true
            cell.viewMoreView.isHidden = false
        }
        return cell
    }

    private func getHomeBannerShowCell(with indexPath: IndexPath, shows: [Show]) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.homeBannerShow,
                                                      for: indexPath) as! BannerShowsCollectionViewCell
        cell.viewController = self.hostViewController
        
        cell.shows = shows
        
        cell.playButtonAction = { index in
           // showWorkInProgress()
            cell.playTrailer(in: self.hostViewController)
        }
        
        // heart button tapped..
        cell.heartButtonAction = { index in
            if !self.sessionCreated {
                self.checkforAccount()
                return false
            }else{
                //add check ...
                if !shows[index].addedToWatchlist {
                    self.processDataForAddToWatchList(contentId: shows[index]._id!)
                } else {
                    let params: [String: Any] = [WebConstants.contentId: shows[index]._id!]
                    self.processDataForRemoveWatchList(params: params)
                }
            }
            return true
        }
        
        // i button tapped..
        cell.infoButtonAction = { index in
            ShowDetailViewController.show(from: self.hostViewController, show: shows[index], isCome: "", universal_showId: "")
        }

        return cell
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
        cell.defaultBorderColor         = .clear
        cell.selectedBorderColor        = .appVoiletBackground
        if UIDevice.current.userInterfaceIdiom == .pad{
            cell.titleFont                  = .appBoldFont(with: 22)
            cell.selectedTitleFont          = .appBoldFont(with: 22)
        }else{
            cell.titleFont                  = .appBoldFont(with: 14)
            cell.selectedTitleFont          = .appBoldFont(with: 14)
        }
    }
}
