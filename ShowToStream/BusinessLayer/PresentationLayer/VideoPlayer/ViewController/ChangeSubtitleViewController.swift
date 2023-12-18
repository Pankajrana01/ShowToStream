//
//  ChangeSubtitleViewController.swift
//  ShowToStream
//
//  Created by 1312 on 30/12/20.
//

import UIKit

class ChangeSubtitleViewController: BaseAlertViewController {
    override class func storyboard() -> UIStoryboard {
        return UIStoryboard.videoPlayer
    }
    
    override class func identifier() -> String {
        return ViewControllerIdentifier.changeSubtitle
    }
    lazy var viewModel = ChangeSubtitleViewModel(hostViewController: self)
    
    override func getViewModel() -> BaseViewModel {
        return viewModel
    }
    
    class func show(over host: UIViewController, subtitles: [String], selectedIndex: Int, isComeFrom: String, completionHandler: @escaping ((Int) -> Void)) {
        let controller = self.getController() as! ChangeSubtitleViewController
        controller.show(over: host, subtitles: subtitles, selectedIndex: selectedIndex, isComeFrom: isComeFrom, completionHandler: completionHandler)
    }

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var titlename: UILabel!
    
    func show(over host: UIViewController, subtitles: [String], selectedIndex:Int, isComeFrom: String, completionHandler: @escaping ((Int) -> Void)) {
        self.viewModel.completionHandler = completionHandler
        self.viewModel.subTitles = subtitles
        self.viewModel.selectedIndex = selectedIndex
        self.viewModel.isComeFrom = isComeFrom
        self.show(over: host)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.viewModel.isComeFrom == StringConstants.audio{
            self.titlename.text = StringConstants.audio
        } else {
            self.titlename.text = StringConstants.subtitle
        }
        self.viewModel.collectionView = collectionView
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: { _ in self.collectionView.collectionViewLayout.invalidateLayout() },
            completion: { _ in })
    }

}
