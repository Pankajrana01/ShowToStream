//
//  ChangeSubtitleViewModel.swift
//  ShowToStream
//
//  Created by 1312 on 30/12/20.
//

import UIKit

class StreamSubtitle: Hashable {
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
    static func == (lhs: StreamSubtitle, rhs: StreamSubtitle) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class ChangeSubtitleViewModel: BaseViewModel {
    var completionHandler: ((Int) -> Void)?
    var subTitles = [String]()
    var selectedIndex = Int()
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    var isComeFrom = ""
    private var datasourceArray : [StreamSubtitle] = []
//        [StreamSubtitle(name: "OFF", isSelected: true),
//                                                     StreamSubtitle(name: "English"),
//                                                     StreamSubtitle(name: "Spanish"),
//                                                     StreamSubtitle(name: "Mandarin"),
//                                                     StreamSubtitle(name: "Arabic"),
//                                                     StreamSubtitle(name: "Hindi"),
//                                                     StreamSubtitle(name: "Filipino"),
//                                                     StreamSubtitle(name: "French"),
//                                                     StreamSubtitle(name: "Irish")]
    
    func updateSubTitles(){
        for i in 0..<subTitles.count{
            if i == self.selectedIndex {
                datasourceArray.append(StreamSubtitle(name: subTitles[i], isSelected: true))
            }  else{
                datasourceArray.append(StreamSubtitle(name: subTitles[i], isSelected: false))
            }
        }
    }
    private func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "StreamSubtitleCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.streamSubtitle)
        populateCollectionView()
    }
    
    private lazy var dataSource = tableViewDataSource()
    
    func tableViewDataSource() -> UICollectionViewDiffableDataSource<Int, StreamSubtitle> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {  collectionView, indexPath, subTitle in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.streamSubtitle,
                                                          for: indexPath) as! StreamSubtitleCollectionViewCell
            cell.subtitle = subTitle
            return cell
        })
    }
    
    private func populateCollectionView() {
        updateSubTitles()
        updateDataSource()
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, StreamSubtitle>()
        snapshot.appendSections([0])
        snapshot.appendItems(datasourceArray, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false) // bug: setting true wont update cells when calling from did select.
    }
    
    func subtitlesUpdated() {
        let index = datasourceArray.firstIndex(where: { $0.isSelected })!
        completionHandler?(index)
        (self.hostViewController as! BaseAlertViewController).dismiss()
    }
}

extension ChangeSubtitleViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 90) / 2, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subtitle = datasourceArray[indexPath.item]
        if !subtitle.isSelected {
            datasourceArray.forEach{ $0.isSelected = false }
            subtitle.isSelected = true
            updateDataSource()
            
            self.hostViewController.view.isUserInteractionEnabled = false
            delay(0.5) {
                self.subtitlesUpdated()
            }
        }
        else{
            datasourceArray.forEach{ $0.isSelected = false }
            subtitle.isSelected = true
            updateDataSource()
            
            self.hostViewController.view.isUserInteractionEnabled = false
            delay(0.5) {
                self.subtitlesUpdated()
            }
        }
    }
}
