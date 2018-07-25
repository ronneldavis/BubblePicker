//
//  BubblePickerNode.swift
//  BubblePicker
//
//  Created by Ronnel Davis on 25/07/18.
//

import UIKit

public class BubblePickerNode: UIView {

    public var label: UILabel!
    var imageView: UIImageView!
    var index: Int!
    var isExpanded = false;

    public init(title: String, color: UIColor, image: UIImage) {

        let isLeft = arc4random_uniform(2)
        var marginLeft:CGFloat = 300;
        if(isLeft == 0){
            marginLeft = -300
        }
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        super.init(frame: CGRect(x: screenWidth/2 + marginLeft - 100 + CGFloat(arc4random_uniform(100)), y: screenHeight/2 - 100 + CGFloat(arc4random_uniform(100)), width: 100, height: 100))

        let maskPath = UIBezierPath(roundedRect: CGRect(x: 3, y: 3, width: frame.width - 6, height: frame.height - 6), cornerRadius: 47)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        self.label = UILabel(frame: self.bounds)
        self.label.text = title
        self.label.textColor = UIColor.white
        self.label.textAlignment = .center
        self.label.font = UIFont(name: "Avenir-Heavy", size: 14)
        self.addSubview(self.label)

        self.backgroundColor = color
        self.clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BubblePickerNode.tapped))
        self.addGestureRecognizer(tapGesture)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @available(iOS 9.0, *)
    override public var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }

    override public var collisionBoundingPath: UIBezierPath{
        return UIBezierPath(ovalIn: self.bounds);
    }

    @objc func tapped(recogniser: UITapGestureRecognizer){
        setSelected(!isExpanded);
    }

    public func setSelected(_ flag: Bool){

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
    }
}
