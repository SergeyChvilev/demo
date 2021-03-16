//
//  Style.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 15.03.2021.
//

import Foundation
import UIKit

fileprivate var isDarkUserInterfaceStyle: Bool {
    if #available(iOS 12.0, *) {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark
    } else {
        return false
    }
}

 enum Style {

     enum Colors {
        static let barColor: UIColor = isDarkUserInterfaceStyle ? #colorLiteral(red: 0.0862745098, green: 0.1098039216, blue: 0.1098039216, alpha: 1) : #colorLiteral(red: 0.1137254902, green: 0.6666666667, blue: 0.8745098039, alpha: 1)
        static let barTintColor: UIColor = isDarkUserInterfaceStyle ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let mainTintColor: UIColor = isDarkUserInterfaceStyle ? #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1) : #colorLiteral(red: 0.1137254902, green: 0.6666666667, blue: 0.8745098039, alpha: 1)
        static let backgroundColor: UIColor = isDarkUserInterfaceStyle ? #colorLiteral(red: 0.1568627451, green: 0.1921568627, blue: 0.2431372549, alpha: 1) : #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        static let backgroundCellColor: UIColor = isDarkUserInterfaceStyle ? #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 1) : #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
    }
}
