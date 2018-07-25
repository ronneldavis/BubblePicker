# BubblePicker

[![CI Status](http://img.shields.io/travis/ronnel_davis@yahoo.com/BubblePicker.svg?style=flat)](https://travis-ci.org/ronnel_davis@yahoo.com/BubblePicker)
[![Version](https://img.shields.io/cocoapods/v/BubblePicker.svg?style=flat)](http://cocoapods.org/pods/BubblePicker)
[![License](https://img.shields.io/cocoapods/l/BubblePicker.svg?style=flat)](http://cocoapods.org/pods/BubblePicker)
[![Platform](https://img.shields.io/cocoapods/p/BubblePicker.svg?style=flat)](http://cocoapods.org/pods/BubblePicker)

A similar library for Android made by Irina Galata can be found [here](https://github.com/igalata/Bubble-Picker)

![Bubble Picker GIF](http://i.giphy.com/lyVR0Y9GrgKti.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Upgrade Warning

Version 1.0 of this library has undergone a comeplete rewrite and will require significant changes to your codebase if you were using the previous version. It now uses a delegate based architecture rather than the previous version which required closures.

## Requirements

BubblePicker requires a deployment target of atleast iOS 9.0 for UIKitDynamics and Swift 4. 

## Usage

Setup the BubblePicker view

```Swift 

let arr = ["TV Shows", "Sports", "Technology", "Science", "People", "Places", "Music", "Photography"]

bubblePicker = BubblePicker()       // Or use a storyboard
bubblePicker.delegate = self;
bubblePicker.reloadData();
```

Implement the delegate methods

```Swift 
extension ViewController: BubblePickerDelegate {

    func numberOfItems(in bubblepicker: BubblePicker) -> Int {
        return items.count;
    }

    func bubblePicker(_: BubblePicker, nodeFor indexPath: IndexPath) -> BubblePickerNode {
        let node = BubblePickerNode(title: items[indexPath.item], color: UIColor.red, image: UIImage());
        return node;
    }
}
```

Delegate callbacks for when a user selects or deselects a bubble

```Swift

func bubblePicker(_: BubblePicker, didSelectNodeAt indexPath: IndexPath) {

}

func bubblePicker(_: BubblePicker, didDeselectNodeAt indexPath: IndexPath) {

}
```


## Installation

BubblePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BubblePicker"
```

## Author

Ronnel Davis: ronneldavis1996@gmail.com

## License

BubblePicker is available under the MIT license. See the LICENSE file for more info.

Copyright (c) 2018 Ronnel Davis
