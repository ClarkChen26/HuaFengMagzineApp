//
//  FlashableView.swift
//  HuaFeng
//
//  Created by Zhijie Chen on 8/19/18.
//  Copyright © 2018 Zhijie Chen. All rights reserved.
//

import UIKit

class FlashableView : UIView {
    let whiteView : UIView
    
    required init?(coder aDecoder: NSCoder) {
        whiteView = UIView()
        super.init(coder: aDecoder)
        whiteView.layer.opacity = 0
        whiteView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func flashView() {
        whiteView.frame = frame
        whiteView.layer.opacity = 1
        addSubview(whiteView)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        whiteView.layer.opacity = 0
        UIView.commitAnimations()
    }
    
}
