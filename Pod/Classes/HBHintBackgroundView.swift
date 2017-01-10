//
//  HBHintBackgroundView.swift
//  Pods
//
//  Created by Stan Potemkin on 09/01/2017.
//
//

import Foundation
import UIKit

final class HBHintBackgroundView: UIView {
    var holeElements = [HoleElement]() {
        didSet { setNeedsDisplay() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isOpaque = false
        layer.needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0, y: -rect.height)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let maskContext = UIGraphicsGetCurrentContext() else { return }
        maskContext.setFillColor(UIColor.black.cgColor)
        maskContext.fill(rect)
        holeElements.map(pathForElement).forEach(maskContext.addPath)
        maskContext.setFillColor(UIColor.white.cgColor)
        maskContext.fillPath()
        guard let mask = maskContext.extractMask() else { return }
        UIGraphicsEndImageContext()
        
        context.saveGState()
        context.clip(to: rect, mask: mask)
        context.setFillColor(UIColor(white: 0, alpha: 0.75).cgColor)
        context.fill(rect)
        context.restoreGState()
    }
    
    private func pathForElement(_ element: HoleElement) -> CGPath {
        switch element {
        case let .ellipse(layoutProvider):
            return CGPath(ellipseIn: layoutProvider(bounds.size), transform: nil)
            
        case let .rectangle(layoutProvider):
            return CGPath(rect: layoutProvider(bounds.size), transform: nil)
        }
    }
}

fileprivate extension CGContext {
    func extractMask() -> CGImage? {
        guard let mask = makeImage() else { return nil }
        guard let data = NSMutableData(length: width * height) else { return nil }
        
        let context = CGContext(
            data: data.mutableBytes,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        )
        
        context?.setBlendMode(.copy)
        context?.draw(mask, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let dataProvider = CGDataProvider(data: data) else { return nil }
        
        let result = CGImage(
            maskWidth: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 8,
            bytesPerRow: width,
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: true
        )
        
        return result
    }
}
