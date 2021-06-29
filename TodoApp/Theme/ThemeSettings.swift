//
//  ThemeSettings.swift
//  TodoApp
//
//  Created by Manoel Filho on 29/06/21.
//

import SwiftUI

//MARK: Theme class
class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme"){
        didSet{
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
}
