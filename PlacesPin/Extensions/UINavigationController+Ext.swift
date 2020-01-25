//
//  UINavigationController+Ext.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 10/10/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import UIKit

extension UINavigationController{
    
    open override var childForStatusBarStyle: UIViewController?{
        return topViewController
    }
}
