//
//  PlaceTableViewCell.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 9/26/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import UIKit




class PlaceTableViewCell: UITableViewCell {

    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!{
        didSet{
            locationLabel.numberOfLines = 0
        }
    }
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!{
        
        didSet{
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2.0
            thumbnailImageView.clipsToBounds = true


            
        }
    }
    
        
    @IBOutlet var checkImageVIew: UIImageView!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
