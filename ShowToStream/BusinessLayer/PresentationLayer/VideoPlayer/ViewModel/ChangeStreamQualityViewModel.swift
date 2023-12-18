//
//  ChangeStreamQualityViewModel.swift
//  ShowToStream
//
//  Created by 1312 on 30/12/20.
//

import UIKit

class StreamQuality: Hashable {
    let identifier: UUID = UUID()
    let name: String
    var isSelected: Bool = false
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    static func == (lhs: StreamQuality, rhs: StreamQuality) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class ChangeStreamQualityViewModel: BaseViewModel {
    var completionHandler: ((Int, String) -> Void)?
    var videoQuality = [String]()
    var selectedIndex = Int()
    weak var tableView: UITableView! { didSet { configureTableView() } }
    weak var tableViewHeight: NSLayoutConstraint!
    
    private var tableViewArray: [StreamQuality] = []
        
//        [StreamQuality(name: "Auto", isSelected: true),
//                                                   StreamQuality(name: "1080 (HD)"),
//                                                   StreamQuality(name: "720"),
//                                                   StreamQuality(name: "480"),
//                                                   StreamQuality(name: "360"),
//                                                   StreamQuality(name: "240")]
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(UINib(nibName: "StreamQualityTableViewCell", bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.streamQuality)
        populateTableView()
    }
    
    func updateQuality(){
        for i in 0..<videoQuality.count{
            if i == self.selectedIndex {
                tableViewArray.append(StreamQuality(name: videoQuality[i], isSelected: true))
            }  else{
                tableViewArray.append(StreamQuality(name: videoQuality[i], isSelected: false))
            }
        }
    }
    private lazy var dataSource = tableViewDataSource()
    
    func tableViewDataSource() -> UITableViewDiffableDataSource<Int, StreamQuality> {
        return UITableViewDiffableDataSource(tableView: tableView, cellProvider: {  tableView, indexPath, streamQuality in
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.streamQuality,
                                                     for: indexPath) as! StreamQualityTableViewCell
            cell.streamQuality = streamQuality
            cell.selectionStyle = .none
            return cell
        })
    }
    
    private func populateTableView() {
        updateQuality()
        updateDataSource()
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, StreamQuality>()
        snapshot.appendSections([0])
        snapshot.appendItems(tableViewArray, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false) // bug: setting true wont update cells when calling from did select.
        tableViewHeight.constant = tableView.contentSize.height + 75
    }
    
    func cancelButtonTapped() {
        (self.hostViewController as! BaseAlertViewController).dismiss()
    }
    
    func okButtonTapped() {
        self.hostViewController.view.isUserInteractionEnabled = false
        delay(1) {
            self.qualityUpdated()
        }
    }
    
    func qualityUpdated() {
        let index = tableViewArray.firstIndex(where: { $0.isSelected })!
        completionHandler?(index, tableViewArray[index].name)
        (self.hostViewController as! BaseAlertViewController).dismiss()
    }
}

extension ChangeStreamQualityViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let streamQuality = tableViewArray[indexPath.row]
        if !streamQuality.isSelected {
            tableViewArray.forEach{ $0.isSelected = false }
            streamQuality.isSelected = true
            updateDataSource()
            
            //self.hostViewController.view.isUserInteractionEnabled = false
            //delay(1) {
            //    self.qualityUpdated()
            //}
        }else{
            tableViewArray.forEach{ $0.isSelected = false }
            streamQuality.isSelected = true
            updateDataSource()
            
            //self.hostViewController.view.isUserInteractionEnabled = false
            //delay(1) {
            //    self.qualityUpdated()
            //}
        }
    }
}
