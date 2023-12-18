//
//  UIViewController+CountryPickerVIew.swift
//  KarGoRider
//
//  Created by Dev on 06/08/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import CountryPickerView
import UIKit

extension UIViewController: CountryPickerViewDataSource {
    public func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        return []
    }
    
    public func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return nil
    }
    
    public func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    public func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
    
    public func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .navigationBar
    }
    
    public func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
}
