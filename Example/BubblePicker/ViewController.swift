//
//  ViewController.swift
//  BubblePicker
//
//  Created by ronnel_davis@yahoo.com on 03/14/2017.
//  Copyright (c) 2017 ronnel_davis@yahoo.com. All rights reserved.
//

import UIKit
import BubblePicker

class ViewController: UIViewController {

    @IBOutlet var bubblePicker: BubblePicker!

    let items = ["TV Shows", "Sports", "Movies", "Events", "Social", "Environment", "Causes", "News", "Technology", "Science", "People", "Places", "Music", "Photography"];

    override func viewDidLoad() {
        super.viewDidLoad()

        bubblePicker.delegate = self;
        bubblePicker.reloadData();
        bubblePicker.setSelected([0, 2, 3, 4]);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: BubblePickerDelegate {

    func numberOfItems(in bubblepicker: BubblePicker) -> Int {
        return items.count;
    }

    func bubblePicker(_: BubblePicker, nodeFor indexPath: IndexPath) -> BubblePickerNode {
        let node = BubblePickerNode(title: items[indexPath.item], color: UIColor.red, image: UIImage(named: "dubai.jpg")!);
        return node;
    }

    func bubblePicker(_: BubblePicker, didSelectNodeAt indexPath: IndexPath) {
        print("Did select");
    }

    func bubblePicker(_: BubblePicker, didDeselectNodeAt indexPath: IndexPath) {
        print("Did deselect");
    }

}
