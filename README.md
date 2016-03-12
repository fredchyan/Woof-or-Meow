# Woof or Meow

Woof or Meow is an iOS application that display images from the [subreddit /r/aww](https://www.reddit.com/r/aww/). It obtains JSON data from Reddit, extract the URLs and download the images from Imgur. User will be able to store or share the image she likes. In addiction, the user can also submit the picture to IBM Watson Visual Recognition Service for further analysis.

![main-photowall](http://i.imgur.com/JtW5LrS.gif)

## Features

### Persistence
In the Image View, there are two buttons to the right of the Navigation Bar. The
Action button allows user to share the image with friends via Message, Facebook
etc. The Save button allows user to add this image to the favorites. This is a helpful feature since Reddit submission ranking is always changing as new post gets submitted and voted. The Reddit submission data (title, url etc.) is stored using **Core Data** while the image is stored in the disk directly, available for viewing even without network connection.

![favorite](http://i.imgur.com/C2EKzpk.gif)

### Visual Recognition
Tapping the star (a **custom UI Control**) on the lower right submits the image to IBM Watson Visual Recognition Service for image classification, the result can be dog, cat, or neither. In any case, the analysis details will be displayed.

![watson](http://i.imgur.com/YKdcafG.gif)

## Getting Started

For basic functionalities without visual analysis, the Xcode project should work directly. For image classification, a backend Node.js instance  on IBM Bluemix needs to be running, it will act as a proxy and submit the image to the visual recognition service for analysis.

1. First, set up the back-end by following the instruction [here](https://github.com/fredchyan/Woof-or-Meow-Backend)

2. Once the back-end is up and running, specify its URL in `Watson.swift`.

    ```swift
    let request = NSMutableURLRequest(URL: NSURL(string: "http://woof-or-meow.mybluemix.net/uploadpic")!)
    ```

3. Build the project and have fun!

## License
The contents of this repository are covered under the [MIT License](LICENSE).