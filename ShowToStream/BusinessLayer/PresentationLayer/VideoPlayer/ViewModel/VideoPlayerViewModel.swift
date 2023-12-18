//
//  VideoPlayerViewModel.swift
//  ShowToStream
//
//  Created by 1312 on 21/12/20.
//

import UIKit
import AVKit

class VideoPlayerViewModel: BaseViewModel {
    var urlString: String! {
        if let urlAsset = self.asset as? AVURLAsset {
            return urlAsset.url.absoluteString
        }
        return ""
    }
    var asset: AVAsset!
    var show : Show!
    var similarShows: [Show] = []
    var user = UserModel.shared.user
    
    weak var collectionView: UICollectionView! { didSet { configureCollectionView() } }
    
    private func configureCollectionView() {
        collectionView.collectionViewLayout = compositionalLayout
        
        //collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = false
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: NibCellIdentifier.homeShowCollectionViewCellNib, bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCellIdentifier.similarShows)
        
        collectionView.register(UINib(nibName: NibCellIdentifier.baseHeaderCollectionReusableViewNib, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionViewCellIdentifier.homeHeader)
    }
    
    func getSimliarShow(){
        let param: [String: Any] = [WebConstants.profileId: KUSERMODEL.selectedProfile._id!, WebConstants.contentId: show._id ?? ""]
        self.processDataForLoginMayYouLike(params: param)
    }
}

extension VideoPlayerViewModel{
    func processDataForLoginMayYouLike(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.Content.mayLikeVideos,
                               params: params,
                               headers: headers,
                               method: .post) { response, _ in
                                if !self.hasErrorIn(response) {
                                    let responseData = response![APIConstants.data] as! [[String:Any]]
                                    var showList = [Show]()
                                    self.similarShows = [Show]()
                                    for rawObject in responseData {
                                        let show = Show()
                                        show.updateWithHomeData(rawObject)
                                        showList.append(show)
                                    }
                                    self.similarShows.append(contentsOf: showList)
                                    if self.collectionView != nil{
                                        self.collectionView.reloadData()
                                    }
                                }
                                hideLoader()
        }
    }
}
