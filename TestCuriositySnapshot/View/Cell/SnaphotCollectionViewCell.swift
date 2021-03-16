//
//  SnaphotCollectionViewCell.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 13.03.2021.
//

import UIKit
import Kingfisher

class SnaphotCollectionViewCell: UICollectionViewCell {
    
    static var Identifier = "shapshot_cell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let errorImage = UIImage(named: "im_error_black")
    
    var imgSrc: String? {
        didSet {
            guard let url = URL(string: imgSrc ?? "") else {
                return
            }
            imageView.isHidden = true
            errorImageView.isHidden = true
            activityIndicatorView.startAnimating()
            imageView.kf.setImage(with: url, placeholder: nil, options: []) { (result) in
                self.activityIndicatorView.stopAnimating()
                switch result{
                case .success(_):
                    self.imageView.isHidden = false
                    self.errorImageView.isHidden = true
                case .failure(_):
                    self.imageView.isHidden = true
                    self.errorImageView.isHidden = false
                    self.errorImageView.image = self.errorImage
                }
            }
        }
    }
    
     var isLongTap: Bool = false {
        didSet {
            if self.isHighlighted {
                UIView.animate(
                    withDuration: 0.1,
                    animations: {
                        self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                })
            } else {
                UIView.animate(
                    withDuration: 0.1,
                    animations: {
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicatorView.color = Style.Colors.mainTintColor
        self.backgroundColor = Style.Colors.backgroundCellColor
        
    }

}
