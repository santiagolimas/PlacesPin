//
//  UIColor+Ext.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 10/10/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int){
        
        let redValue = CGFloat(red) / 255
        let greenValue = CGFloat(green) / 255
        let blueValue = CGFloat(blue) / 255
        self.init(red:redValue, green:greenValue, blue:blueValue, alpha: 1.0)
    }
}
