//
//  MetalView.swift
//  bevy_in_iOS
//
//  Created by Jinlei Li on 2022/12/20.
//

import UIKit
import Foundation

class MetalView: UIView {
    override class var layerClass: AnyClass {
        return CAMetalLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configLayer()
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    private func configLayer() {
        guard let layer = self.layer as? CAMetalLayer else {
            return
        }
        layer.presentsWithTransaction = false
        layer.framebufferOnly = true
        // nativeScale is real physical pixel scale
        // https://tomisacat.xyz/tech/2017/06/17/scale-nativescale-contentsscale.html
        self.contentScaleFactor = UIScreen.main.nativeScale
    }
}

