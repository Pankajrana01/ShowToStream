//
//  DeleteProfileViewModel.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 29/12/20.
//

import Foundation

class DeleteProfileViewModel : BaseViewModel {
    var profile: Profile!

    var completionHandler: (() -> Void)?
    
    func deleteButtonTapped() {
        if let id = profile._id {
            processData(params: [WebConstants.id: id])
        }
    }

    fileprivate func deleteSuccess() {
        completionHandler?()
        (self.hostViewController as! BaseAlertViewController).dismiss()
    }

}

extension DeleteProfileViewModel {
    func processData(params: [String: Any]) {
        showLoader()
        let headers: [String: String] = [WebConstants.authorization: UserModel.shared.authorizationToken]
        ApiManager.makeApiCall(APIUrl.MyAccount.profile,
                               params: params,
                               headers: headers,
                               method: .delete) { response, _ in
                                if !self.hasErrorIn(response) {
                                    if let rawProfiles = response?[APIConstants.data] as? [[String: Any]] {
                                        if KUSERMODEL.selectedProfile == self.profile {
                                            KUSERMODEL.selectedProfileIndex = 0
                                        }
                                        KUSERMODEL.updateProfiles(rawProfiles)
                                        KAPPSTORAGE.user = KUSERMODEL.user
                                        self.deleteSuccess()
                                    }
                                }
                                hideLoader()
        }
    }
}
