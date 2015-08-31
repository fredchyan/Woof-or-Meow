Description The Woof or Meow app pulls pictures from the subreddit /r/aww. It
obtains JSON data from Reddit, extract the URLs and download the images from
Imgur. The user can then choose to perform analysis using Watson’s Visual
Recognition service It posts to a Node.js app on IBM Bluemix that listens for
image, calls Watson API, and then return the analysis result in JSON format.

Usage On the main screen, user can tap on any image to enter individual Image
View.

In the Image View, there are two buttons on the right of the Navigation Bar. The
Action button allows user to share the image with friends via Message, Facebook
etc. The Save button allows user to add this image to the favorites. This also
adds the image to persistent context, and will be stored in the hard disk,
available for viewing even without network connection. Lastly, there is a star
button on the lower right, which is a custom UIControl, tap it to perform Visual
Recognition using Watson. The result will be displayed via an AlertView.

On the main screen, user can tap the Favorite button on the navigation bar to
enter the Favorite View. In Favorite View, user is presented with a list of
persisted images. Tap on any of them to enter Image View, or, use the Edit
button to remove unwanted entry.

