//
//  BubblePicker.swift
//  conversations
//
//  Created by Ronnel Davis on 10/03/17.
//  Copyright © 2017 Ronnel Davis. All rights reserved.
//

import UIKit

var BPAnimator: UIDynamicAnimator!
var BPCollision: UICollisionBehavior!
var BPGravity: UIFieldBehavior!
var BPDynamics: UIDynamicItemBehavior!

var BPSelectHandler: (Int) -> () = { _ in }
var BPDeselectHandler: (Int) -> () = { _ in }
var BPSelectedIndices = [Int]()

public enum BPTheme {
    case light
    case dark
}

var BPGradients = [["#FF5E3AFF", "#FF2A68FF"], ["#FF9500FF", "#FF5E3AFF"], ["#87FC70FF", "#0BD318FF"], ["#52EDC7FF", "#5AC8FBFF"], ["#1AD6FDFF", "#1AD6FDFF"], ["#C644FCFF", "#5856D6FF"], ["#EF4DB6FF", "#C643FCFF"], ["#4A4A4AFF", "#2B2B2BFF"], ["#DBDDDEFF", "#898C90FF"]]

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

class Ellipse: UIView {
    var label: UILabel!
    var imageView: UIImageView!
    var index: Int!
    var bgImage: UIImageView!
    var isExpanded = false;

    override init(frame: CGRect) {
        super.init(frame: frame)

        let maskPath = UIBezierPath(roundedRect: CGRect(x: 3, y: 3, width: frame.width - 6, height: frame.height - 6), cornerRadius: 47)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        self.label = UILabel(frame: self.bounds)
        self.label.text = ""
        self.label.textColor = UIColor.white
        self.label.textAlignment = .center
        self.label.font = UIFont(name: "Avenir-Heavy", size: 14)
        self.addSubview(self.label)

        var gradient = BPGradients[0]
        let bottomColor = UIColor(hexString: gradient[0])!.cgColor
        let topColor = UIColor(hexString: gradient[1])!.cgColor
        let shapeTexture = UIImage(size:self.frame.size, color1:bottomColor, color2:topColor)

        self.backgroundColor = UIColor(patternImage: shapeTexture)
        self.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Ellipse.tapped))
        self.addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @available(iOS 9.0, *)
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }

    override var collisionBoundingPath: UIBezierPath{
        return UIBezierPath(ovalIn: self.bounds);
    }

    func tapped(recogniser: UITapGestureRecognizer){
        setSelected(!isExpanded);
    }

    func setSelected(_ flag: Bool){

        isExpanded = flag;

        BPAnimator.removeBehavior(BPDynamics)
        BPAnimator.removeBehavior(BPGravity)
        BPAnimator.removeBehavior(BPCollision)

        var maskPath: UIBezierPath!

        if(!isExpanded){
            self.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))

            maskPath = UIBezierPath(roundedRect: CGRect(x: 3, y: 3, width: bounds.width - 6, height: bounds.height - 6), cornerRadius: 47)

            self.label.frame = self.bounds
            self.label.font = UIFont(name: "Avenir-Heavy", size: 14)
            BPSelectedIndices.remove(at: BPSelectedIndices.index(of: self.index)!)
        }
        else{
            self.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 160, height: 160))

            maskPath = UIBezierPath(roundedRect: CGRect(x: 3, y: 3, width: bounds.width - 6, height: bounds.height - 6), cornerRadius: 77)

            self.label.frame = self.bounds
            self.label.font = UIFont(name: "Avenir", size: 22)
            BPSelectedIndices.append(self.index);
        }

        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        BPAnimator.addBehavior(BPDynamics)
        BPAnimator.addBehavior(BPGravity)
        BPAnimator.addBehavior(BPCollision)

        if(isExpanded){
            BPSelectHandler(index)
        }
        else{
            BPDeselectHandler(index)
        }
    }
}


public class BubblePicker: UIView {

    public var theme: BPTheme! {
        didSet{
            for circle in circles{
                if(theme == .light){
                    circle.label.textColor = .white
                }
                else{
                    circle.label.textColor = .black
                }
            }
        }
    }

    var circles = [Ellipse]()
    var gravPos: CGPoint!

    func newCircle(_ index: Int) -> Ellipse{
        let isLeft = arc4random_uniform(2)
        var marginLeft:CGFloat = 300;
        if(isLeft == 0){
            marginLeft = -300
        }
        let Circle = Ellipse(frame: CGRect(x: frame.midX + marginLeft - 100 + CGFloat(arc4random_uniform(100)), y: frame.midY - 100 + CGFloat(arc4random_uniform(100)), width: 100, height: 100))
        circles.append(Circle)
        Circle.index = index;
        return Circle;
    }

    override public init(frame: CGRect) {
        super.init(frame: frame);
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    public func setSelectedBubble(_ index: Int, _ flag: Bool){
        circles[index].setSelected(flag);
    }

    public func setSelectedBubbles(_ indices: [Int], _ flag: Bool){
        for index in indices{
            circles[index].setSelected(flag);
        }
    }

    public func getSelectedBubbles() -> [Int]{
        return BPSelectedIndices;
    }

    public func onBubbleSelected(_ callback: @escaping (Int)->()){
        BPSelectHandler = callback;
    }

    public func onBubbleDeselected(_ callback: @escaping (Int)->()){
        BPDeselectHandler = callback;
    }


    public func setup(items: Array<String>){
        BPAnimator = UIDynamicAnimator(referenceView: self)
        //animator.isDebugEnabled = true // Private API. See the bridging header.
        self.isUserInteractionEnabled = true

        BPGravity = UIFieldBehavior.radialGravityField(position: self.center)
        BPGravity.falloff = 0.3
        BPGravity.strength = 3
        BPGravity.animationSpeed = 7
        gravPos = CGPoint(x: frame.midX, y: frame.midY)

        var i = 0;
        for item in items{
            let circle = newCircle(i)
            circle.label.text = item
            self.addSubview(circle)
            BPGravity.addItem(circle)
            i += 1
        }

        BPDynamics = UIDynamicItemBehavior(items: circles);
        BPDynamics.allowsRotation = false;
        BPDynamics.resistance = 0.8

        BPCollision = UICollisionBehavior(items: circles)
        BPCollision.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 0, left: -500, bottom: 0, right: -500))

        BPAnimator.addBehavior(BPDynamics)
        BPAnimator.addBehavior(BPGravity)
        BPAnimator.addBehavior(BPCollision)

        let gestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(BubblePicker.panned));
        self.addGestureRecognizer(gestureRecogniser);
    }


    func panned(recogniser: UIPanGestureRecognizer){
        var newX = gravPos.x + recogniser.translation(in: self).x;
        newX = max(0, newX);
        newX = min(frame.width, newX);

        let newY = gravPos.y;
        
        switch recogniser.state {
        case .ended:
            gravPos = CGPoint(x: newX, y: newY)
            break;
            
        case .changed:
            BPGravity.position = CGPoint(x: newX, y: newY)
            break;
            
        default:
            print("panning");
        }
    }
    
}
