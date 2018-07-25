//
//  Extensions.swift
//  BubblePicker
//
//  Created by Ronnel Davis on 25/07/18.
//

import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.characters.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)

            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

extension UIImage {
    convenience init(size:CGSize,color1:CGColor,color2:CGColor) {
        let scale = UIScreen.main.scale

        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        let context = UIGraphicsGetCurrentContext()

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0,y: 0, width: size.width, height: size.height)
        gradient.colors = [color1,color2]
        gradient.render(in: context!)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.init(cgImage:(image?.cgImage!)!)
    }
}
