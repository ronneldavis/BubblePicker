//
//  BubblePicker.swift
//
//  Created by Ronnel Davis on 10/03/17.
//  Copyright © 2017 Ronnel Davis. All rights reserved.
//

import UIKit


public protocol BubblePickerDelegate: AnyObject {

    func numberOfItems(in bubblepicker: BubblePicker) -> Int;
    func bubblePicker(_: BubblePicker, nodeFor indexPath: IndexPath) -> BubblePickerNode;
    func bubblePicker(_: BubblePicker, didSelectNodeAt indexPath: IndexPath);
    func bubblePicker(_: BubblePicker, didDeselectNodeAt indexPath: IndexPath);

}

public class BubblePicker: UIView {

    public weak var delegate: BubblePickerDelegate?
    public var selectedIndices = [Int]()

    var nodes = [BubblePickerNode]()

    var BPAnimator: UIDynamicAnimator!
    var BPCollision: UICollisionBehavior!
    var BPGravity: UIFieldBehavior!
    var BPDynamics: UIDynamicItemBehavior!

    var gravPos: CGPoint!

    override public init(frame: CGRect) {
        super.init(frame: frame);
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    public func getSelected() -> [Int]{
        return selectedIndices;
    }

    public func setSelected(_ arr: [Int]){
        self.selectedIndices = arr;

        for node in self.nodes{
            if(selectedIndices.contains(node.index)){
                node.setSelected(true);
            }
            else{
                node.setSelected(false);
            }
        }
    }

    public func reloadData(){
        
        guard let delegate = delegate else {
            return
        }

        nodes = [BubblePickerNode]()
        let items = delegate.numberOfItems(in: self);

        BPAnimator = UIDynamicAnimator(referenceView: self)
        //BPAnimator.setValue(true, forKey: "debugEnabled") // Private API. See the bridging header.
        self.isUserInteractionEnabled = true

        BPGravity = UIFieldBehavior.radialGravityField(position: self.center)
        BPGravity.falloff = 0.3
        BPGravity.strength = 3
        BPGravity.animationSpeed = 7
        gravPos = CGPoint(x: frame.midX, y: frame.midY)

        for i in 0..<items{
            let node = delegate.bubblePicker(self, nodeFor: IndexPath(item: i, section: 0))
            node.index = i;
            node.bubblepicker = self;
            nodes.append(node);
            self.addSubview(node)
            BPGravity.addItem(node)
        }

        BPDynamics = UIDynamicItemBehavior(items: nodes);
        BPDynamics.allowsRotation = false;
        BPDynamics.resistance = 0.8

        BPCollision = UICollisionBehavior(items: nodes)
        BPCollision.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 0, left: -500, bottom: 0, right: -500))

        BPAnimator.addBehavior(BPDynamics)
        BPAnimator.addBehavior(BPGravity)
        BPAnimator.addBehavior(BPCollision)

        let gestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(BubblePicker.panned));
        self.addGestureRecognizer(gestureRecogniser);
    }


    @objc func panned(recogniser: UIPanGestureRecognizer){
        var newX = gravPos.x + recogniser.translation(in: self).x;
        newX = max(0, newX);
        newX = min(frame.width, newX);

        var newY = gravPos.y + recogniser.translation(in: self).y;
        newY = max(frame.height*0.25, newY);
        newY = min(frame.height*0.75, newY);
        
        switch recogniser.state {
        case .ended:
            gravPos = CGPoint(x: newX, y: newY)
            break;
            
        case .changed:
            BPGravity.position = CGPoint(x: newX, y: newY)
            break;
            
        default: break;
        }
    }
    
}
