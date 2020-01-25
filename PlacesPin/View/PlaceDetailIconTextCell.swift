//
//  PlaceDetailIconTextCell.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 10/9/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import UIKit

class PlaceDetailIconTextCell: UITableViewCell {

    
    @IBOutlet var iconImageView: UIImageView!
    
    @IBOutlet var shortTextLabel: UILabel!{
           didSet{
               shortTextLabel.numberOfLines = 0
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
