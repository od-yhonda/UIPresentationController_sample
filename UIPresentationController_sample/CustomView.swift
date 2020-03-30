//
//  CustomView.swift
//  UIPresentationController_sample
//
//  Created by yhonda on 2020/03/27.
//  Copyright © 2020 yhonda. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    @IBOutlet weak var label: UILabel! {
        didSet {}
    }
    
//    override var intrinsicContentSize: CGSize {
//        var size = label.bounds.size
//        size.width += 20
//        size.height += 20
//        return size
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        invalidateIntrinsicContentSize()
//        frame.size = intrinsicContentSize
//
//        setNeedsDisplay()
//    }
}
