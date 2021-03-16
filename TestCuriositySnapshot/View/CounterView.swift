//
//  CounterView.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 13.03.2021.
//

import UIKit

class CounterView: UIView {
        let currentCameraLabel = UILabel()
        var currentCameraString: String {
            didSet {
                updateLabel()
            }
        }

    init(frame: CGRect, currentCameraString: String) {

        self.currentCameraString = currentCameraString


            super.init(frame: frame)

            configureLabel()
            updateLabel()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func configureLabel() {

            currentCameraLabel.textAlignment = .center
            self.addSubview(currentCameraLabel)
        }

        private func updateLabel() {
            
            currentCameraLabel.attributedText = NSAttributedString(string: currentCameraString, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white])
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            currentCameraLabel.frame = self.bounds
        }
    }
