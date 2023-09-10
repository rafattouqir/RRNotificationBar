## RRNotificationBar [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/rafattouqir/RRNotificationBar)
> iOS 10 like notification bar.

**iOS 10** like notification bar designed for in-app notification messages showing for iOS 10 and below versions. In iOS 9~10, it can be used to show after an in-app remote notification is received and for multiple purposes.


![Animation](screencast.gif "Animation")
## Installation

#### CocoaPods:

`pod 'RRNotificationBar'`

#### Manually:
Drag the `RRNotificationBar/RRNotificationBar.swift` file into your project.

## Example

**Show**
```swift
RRNotificationBar().show(title: "Awesome Title", message: "Cool message received",onTap:{
            print("tapped")
        })
```

**Hide** 
>Though it hides automatically,you can force hide it.
```swift
let notificationBar = RRNotificationBar()
//after showing,hide if needed before timeout
notificationBar.hide()
```

## License
[MIT LICENSE](LICENSE.md)

To the extent possible under law, [RAFAT](mailto:rafsun.ra@gmail.com) has waived all copyright and related or neighboring rights to this work.

