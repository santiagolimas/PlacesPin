//
//  PlaceDetailHeaderView.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 10/9/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import UIKit

class PlaceDetailHeaderView: UIView {

    
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!{
        didSet{
            nameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var typeLabel: UILabel!{
        didSet{
            typeLabel.layer.cornerRadius = 5.0
            typeLabel.layer.masksToBounds = true
        }
    }
    
    
    @IBOutlet var checkImageView: UIImageView!{
        didSet{
            checkImageView.image = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate)
            checkImageView.tintColor = .white
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
