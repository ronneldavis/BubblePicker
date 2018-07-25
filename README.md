# BubblePicker

[![CI Status](http://img.shields.io/travis/ronnel_davis@yahoo.com/BubblePicker.svg?style=flat)](https://travis-ci.org/ronnel_davis@yahoo.com/BubblePicker)
[![Version](https://img.shields.io/cocoapods/v/BubblePicker.svg?style=flat)](http://cocoapods.org/pods/BubblePicker)
[![License](https://img.shields.io/cocoapods/l/BubblePicker.svg?style=flat)](http://cocoapods.org/pods/BubblePicker)
[![Platform](https://img.shields.io/cocoapods/p/BubblePicker.svg?style=flat)](http://cocoapods.org/pods/BubblePicker)

A similar library for Android made by Irina Galata can be found [here](https://github.com/igalata/Bubble-Picker)

![Bubble Picker GIF]
(http://i.giphy.com/lyVR0Y9GrgKti.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

BubblePicker requires a deployment target of atleast iOS 9.0 for UIKitDynamics

## Usage

Setup the BubblePicker view

```Swift 
bubblePicker = BubblePicker()       // Or use a storyboard
let arr = ["TV Shows", "Sports", "Technology", "Science", "People", "Places", "Music", "Photography"]
bubblePicker.setup(items: arr)
```

Set theme to be either `.light` or `.dark`

```Swift
bubblePicker.theme = .light
bubblePicker.theme = .dark
```

Set bubbles to be selected

```Swift 
bubblePicker.setSelectedBubble(3, true)
bubblePicker.setSelectedBubble(1, true) 
bubblePicker.setSelectedBubble(4, true)
```

Or to set them all in one go

```Swift 
bubblePicker.setSelectedBubbles([3, 1, 4], true);
```

Callbacks for when a user selects or deselects a bubble

```Swift
bubblePicker.onBubbleSelected({
    index in
    print(index)
})
  
bubblePicker.onBubbleDeselected({
    index in
    print(index)
})
```

To get indexes of all selected bubbles

```Swift
let selectedIndices: [Int] = bubblePicker.getSelectedBubbles()
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

Copyright (c) 2017 Ronnel Davis
