//
//  ReflectiveShadowView.swift
//  LetSwift
//
//  Created by Kinga Wilczek, Marcin Chojnacki on 24.04.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import CoreGraphics

class ReflectionShadowView: UIView {
    
    private enum Constants {
        static let heightMultiplier: CGFloat = 0.06
    }
    
    @IBInspectable var blurRadius: CGFloat = 10.0 {
        didSet {
            blurImage()
        }
    }
    
    @IBInspectable var blurPercentageSize: CGFloat = 0.3 {
        didSet {
            blurImage()
        }
    }
    
    @IBInspectable var blurOffsetX: CGFloat = 0.4 {
        didSet {
            blurImage()
        }
    }
    
    @IBInspectable var blurOffsetY: CGFloat = 0.2 {
        didSet {
            blurImage()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return imageView.layer.cornerRadius
        }
        set {
            imageView.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var image: UIImage? {
        set {
            imageView.image = newValue
            blurImage()
        }
        get {
            return imageView.image
        }
    }
    
    var imageSize: CGSize {
        guard contentMode == .scaleAspectFit, let image = imageView.image else { return frame.size }
    
        let widthRatio = imageView.bounds.size.width / image.size.width
        let heightRatio = imageView.bounds.size.height / image.size.height
        let scale = min(widthRatio, heightRatio)
        let imageWidth = scale * image.size.width
        let imageHeight = scale * image.size.height
        
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    var imageView: UIImageView!
    var shadowImageView: UIImageView!
    
    init(image: UIImage) {
        let frame = CGRect(origin: .zero, size: image.size)
        super.init(frame: frame)
        
        setShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setShadow()
    }
    
    func blurImage() {
        guard let imageToBlur = image,
            let resizedImage = imageToBlur.resized(with: blurPercentageSize),
            let ciImage = CIImage(image: resizedImage),
            let blurredImage = appendBlur(ciImage: ciImage) else { return }
            
        DispatchQueue.main.async {
            self.shadowImageView.image = blurredImage
        }
    }
    
    func appendBlur(ciImage: CIImage) -> UIImage? {
        guard let filter = CIFilter(name: "CIGaussianBlur") else { return nil }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let context = CIContext(options: [:])
        if let output = filter.outputImage,
            let cgImage = context.createCGImage(output, from: ciImage.extent) {
            
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        layoutShadow()
    }
    
    private func setShadow() {
        imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = contentMode
        shadowImageView = UIImageView()
        shadowImageView.contentMode = contentMode
        blurImage()
        
        addSubview(shadowImageView)
        addSubview(imageView)
    }
    
    private func layoutShadow() {
        guard let shadowImageView = shadowImageView else { return }
        
        var newBounds = CGRect.zero
        newBounds.size.width = imageSize.width + imageSize.width * blurOffsetX
        newBounds.size.height = imageSize.height + imageSize.height * blurOffsetY
        
        shadowImageView.frame = newBounds
        shadowImageView.center = imageView.center
        shadowImageView.center.y = imageView.center.y + imageSize.height * Constants.heightMultiplier
        
        let mask = CALayer()
        mask.contents = UIImage(named: "ShadowMask")?.cgImage
        mask.frame =  shadowImageView.bounds
        
        shadowImageView.layer.mask = mask
        shadowImageView.layer.masksToBounds = true
    }
}