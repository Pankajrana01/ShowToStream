//
//  WatchlistViewModel.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import SwipeCellKit
import UIKit

class WatchlistViewModel: BaseViewModel {
    var titleName = ""
    var comeFrom = ""
    weak var tableView: UITableView! { didSet { configureTableView() } }
    weak var placeholderView: UIView!
    weak var topBar: UIView!
    var watchlistShows : [Show] = []
    var show : [Show] = []
    var continueWatching: [Show] = []
    var selectedCategoryId = ""
    var categoryData: [Show] = []
    var timerArray = [Date]()
    lazy var refreshTimer = Timer()
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            tableView.contentInset = UIEdgeInsets(top: -3, left: 0, bottom: 170, right: 0)
        }else{
            tableView.contentInset = UIEdgeInsets(top: -3, left: 0, bottom: 140, right: 0)
        }
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.watchlistCell, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.watchlistCell)
        
        tableView.register(UINib(nibName: TableViewNibIdentifier.continueWatching, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.continueWatching)
    }
    
    override func viewLoaded() {
        super.viewLoaded()
        
    }

    fileprivate func reloadView(reloadTableView: Bool = true) {
        if reloadTableView {
            tableView.reloadData()
        }
        placeholderView.isHidden = !watchlistShows.isEmpty || !continueWatching.isEmpty || !categoryData.isEmpty
        topBar.backgroundColor = placeholderView.isHidden ? .appLightBlack : .black
    }
    
    func exploreButtonTapped() {
        SearchViewController.show(from: self.hostViewController, forcePresent: false, isCome: StringConstants.watchList)
        (self.hostViewController.tabBarController as? LandingViewController)? .selectTab(at: 1)
    }
    
    func getCategoryData(id: String){
        let params: [String: Any] = [WebConstants.categoryId: id]
        self.processDataForSelectedCategoryData(params: params)
    }
}

extension WatchlistViewModel : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comeFrom == WebConstants.continueWatching{
            return continueWatching.count
        } else if selectedCategoryId != ""{
            return categoryData.count
        } else{
            return watchlistShows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if comeFrom == WebConstants.continueWatching{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.continueWatching) as! ContinueWatchingTableViewCell
            cell.show = continueWatching[indexPath.row]
            
            if continueWatching[indexPath.row].timeLeft != "" {
                validateTimer()
                self.configureCell(with: cell, timerArray: self.timerArray, indexPath: indexPath)
            }
            
           
            cell.selectionStyle = .none
            return cell
        }
        else if selectedCategoryId != ""{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.watchlistCell) as! WatchlistTableViewCell
            cell.show = categoryData[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.watchlistCell) as! WatchlistTableViewCell
            cell.show = watchlistShows[indexPath.row]
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return 160
        }else{
            return 130
        }
    }
    // MARK:- Timer
    func validateTimer() {
        self.refreshTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.reloadCells), userInfo: nil, repeats: true)
        RunLoop.current.add(self.refreshTimer, forMode: RunLoop.Mode.common)
    }
    
    @objc func reloadCells() {
        if self.tableView != nil{
            let visibleCells = self.tableView.visibleCells
            for cell in visibleCells {
                if let TableCell = cell as? ContinueWatchingTableViewCell {
                    let indexPath = self.tableView.indexPath(for: TableCell)
                    if ((indexPath?.row)! < self.timerArray.count) {
                        self.configureCell(with: TableCell, timerArray: self.timerArray, indexPath: indexPath!)
                    }
                }
            }
        }
    }
    
    // MARK:- Configure Cell
    func configureCell(with cell:UITableViewCell, timerArray:[Date], indexPath:IndexPath)
    {
        guard let Cell = cell as? ContinueWatchingTableViewCell, timerArray.count > 0  else {
            return
        }

        let interval = Int((timerArray[indexPath.row] as AnyObject).timeIntervalSince(Date()))
        if (interval <= 0) {
            Cell.timeLabel.text = "00:00:00"
           // processDataForLoginContinueList()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comeFrom == WebConstants.continueWatching{
            ShowDetailViewController.show(from: self.hostViewController, show: self.continueWatching[indexPath.row], isCome: "", universal_showId: "")
        }else if selectedCategoryId != ""{
            ShowDetailViewController.show(from: self.hostViewController, show: self.categoryData[indexPath.row], isCome: "", universal_showId: "")
        }
        else{
            ShowDetailViewController.show(from: self.hostViewController, show: self.watchlistShows[indexPath.row], isCome: "", universal_showId: "")
        }
    }
        
}

extension WatchlistViewModel: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .border
        return options
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: StringConstants.remove) { action, indexPath in
            
            let alert = UIAlertController(title: StringConstants.removeWatchlistConfirm, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: StringConstants.remove, style: .destructive)  { _ in
                let params: [String: Any] = [WebConstants.contentId: self.watchlistShows[indexPath.row]._id!]
                self.processDataForRemoveWatchList(index: indexPath.row, params: params)
               // tableView.deleteRows(at: [indexPath], with: .automatic)
            })

            alert.addAction(UIAlertAction(title: StringConstants.no, style: .default, handler: nil))
            self.hostViewController.present(alert, animated: true, completion: nil)

        }
        // customize the action appearance
        deleteAction.image = #imageLiteral(resourceName: "Remove")

        return [deleteAction]
    }
}

extension WatchlistViewModel {
    func processDataForWatchList() {
        showLoader()
        var params = [String:Any]()
        params[WebConstants.profileId] = KUSERMODEL.selectedProfile._id!
        print(params)
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Profile.watchList,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.watchlistShows = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithWatchlistData(rawObject)
                                        showList.append(show)
                                    }
                                    self.watchlistShows.append(contentsOf: showList)
                                    self.reloadView()
                                }
                                hideLoader()
        }
    }
    
    func processDataForRemoveWatchList(index:Int, params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Profile.removeWatchList,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    showMessage(with: StringConstants.watchlistRemove)
                                    self.watchlistShows.remove(at: index)
                                    self.reloadView(reloadTableView: true)
                                }
                                hideLoader()
        }
    }
    
    func processDataForLoginContinueList() {
        showLoader()
        var params = [String:Any]()
        params[WebConstants.limit] = PageLimit.defaultLimit
        params[WebConstants.skip] = 0
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.continueList,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.continueWatching = [Show]()
                                    self.show = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithContinuelistData(rawObject )
                                        showList.append(show)
                                    }
                                    self.show.append(contentsOf: showList)
                                    self.continueWatching.append(contentsOf: showList)
                                    self.bindData()
                                    self.reloadView()
                                }
                                hideLoader()
        }
    }
    
    // MARK:- Bind Data
    func bindData() {
        self.timerArray.removeAll()
        for index in 0 ..<  self.continueWatching.count  {
            let item = self.continueWatching[index]
            let timer = item.timeLeft ?? "00:00:00"

           // guard let timer = item.timeLeft else { return }
            if timer == "" {
                let seconds = 0
                let date =  Date(timeIntervalSinceNow: TimeInterval(seconds))
                self.timerArray.append(date)
            } else {
                let seconds = self.getTimerStartValueInSeconds(with: timer)
                let date =  Date(timeIntervalSinceNow: TimeInterval(seconds))
                self.timerArray.append(date)
            }
        }
    }
    
    private func getTimerStartValueInSeconds(with value:String) -> Int {
        let array = value.components(separatedBy: ":")
        let hours = (Int(array[0]) ?? 0) * 60 * 60
        let minutes = (Int(array[1]) ?? 0) * 60
        let seconds = (Int(array[2]) ?? 0)
        return Int(hours + minutes + seconds)
    }
}

extension WatchlistViewModel {
    func processDataForSelectedCategoryData(params: [String: Any]) {
        showLoader()
        if KUSERMODEL.isLoggedIn() {
            let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
            ApiManager.makeApiCall(APIUrl.Content.getCategoryContentV1,
                                   params: params,
                                   headers: headers,
                                   method: .post) { response, _ in
                                    if !self.hasErrorIn(response) {
                                        let responseData = response![APIConstants.data] as! [[String:Any]]
                                        var showList = [Show]()
                                        self.categoryData = [Show]()
                                        for rawObject in responseData {
                                            let show = Show()
                                            show.updateWithHomeData(rawObject)
                                            showList.append(show)
                                        }
                                        self.categoryData.append(contentsOf: showList)
                                        self.reloadView()
                                    }
                                    hideLoader()
            }
        } else {
            let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
            ApiManager.makeApiCall(APIUrl.HomeCommon.getCategoryContent,
                                   params: params,
                                   headers: headers,
                                   method: .post) { response, _ in
                                    if !self.hasErrorIn(response) {
                                        let responseData = response![APIConstants.data] as! [[String:Any]]
                                        var showList = [Show]()
                                        self.categoryData = [Show]()
                                        for rawObject in responseData {
                                            let show = Show()
                                            show.updateWithHomeData(rawObject)
                                            showList.append(show)
                                        }
                                        self.categoryData.append(contentsOf: showList)
                                        self.reloadView()
                                    }
                                    hideLoader()
            }
        }
        
    }
}
