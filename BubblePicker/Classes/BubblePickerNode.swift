//
//  BubblePickerNode.swift
//  BubblePicker
//
//  Created by Ronnel Davis on 25/07/18.
//

import UIKit

public class BubblePickerNode: UIView {

    public var font: UIFont = UIFont(name: "Avenir-Heavy", size: 14)!
    public var selectedFont: UIFont = UIFont(name: "Avenir", size: 22)!
    public var textColor: UIColor = UIColor.white

    var bubblepicker: BubblePicker!

    var label: UILabel!
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

        imageView = UIImageView(image: image);
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100);
        imageView.alpha = 0;
        self.addSubview(imageView);

        let maskPath = UIBezierPath(roundedRect: CGRect(x: 3, y: 3, width: frame.width - 6, height: frame.height - 6), cornerRadius: 47)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        self.label = UILabel(frame: self.bounds)
        self.label.text = title
        self.label.textColor = self.textColor
        self.label.textAlignment = .center
        self.label.font = self.font;
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
        if(isExpanded){
            self.bubblepicker.delegate?.bubblePicker(self.bubblepicker, didDeselectNodeAt: IndexPath(item: self.index, section: 0))
            self.bubblepicker.selectedIndices.remove(at: self.bubblepicker.selectedIndices.index(of: self.index)!)
        }
        else{
            self.bubblepicker.delegate?.bubblePicker(self.bubblepicker, didSelectNodeAt: IndexPath(item: self.index, section: 0))
            self.bubblepicker.selectedIndices.append(self.index);
        }
        setSelected(!isExpanded);
    }

    func setSelected(_ flag: Bool){

        isExpanded = flag;

        self.bubblepicker.BPAnimator.removeBehavior(self.bubblepicker.BPDynamics)
        self.bubblepicker.BPAnimator.removeBehavior(self.bubblepicker.BPGravity)
        self.bubblepicker.BPAnimator.removeBehavior(self.bubblepicker.BPCollision)

        var maskPath: UIBezierPath!

        if(!isExpanded){
            self.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))

            maskPath = UIBezierPath(roundedRect: CGRect(x: 3, y: 3, width: bounds.width - 6, height: bounds.height - 6), cornerRadius: 47)

            imageView.frame = CGRect(x: 0, y: 0, width: 160, height: 160);
            imageView.alpha = 0;

            self.label.frame = self.bounds
            self.label.font = self.font
        }
        else{
            self.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 160, height: 160))

            imageView.frame = CGRect(x: 0, y: 0, width: 160, height: 160);
            imageView.alpha = 0.5;

            maskPath = UIBezierPath(roundedRect: CGRect(x: 3, y: 3, width: bounds.width - 6, height: bounds.height - 6), cornerRadius: 77)

            self.label.frame = self.bounds
            self.label.font = self.selectedFont;
        }

        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        self.bubblepicker.BPAnimator.addBehavior(self.bubblepicker.BPDynamics)
        self.bubblepicker.BPAnimator.addBehavior(self.bubblepicker.BPGravity)
        self.bubblepicker.BPAnimator.addBehavior(self.bubblepicker.BPCollision)
    }
}
