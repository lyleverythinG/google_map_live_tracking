# Google_Maps_Live_Tracking
_This project shows a simple example of tracking a user location in real time and display it in Google Maps with polylines and custom marker_.

Additional Info:
- Add your google api key in androidmanifest.xml, home.dart.
- You need to add a billing account in google cloud console for your api_key to work.
- You can create a google api key in the google cloud console.
- You need to enable Directions API in the google cloud console for the functionality to work.

_Note: This is just a simple and quick demo to give an idea of how to implement this functionality in Flutter_

_Note2: You can play with the initial location and destination for the polylines by changing the hard-coded coordinates_

# How to simulate route in Android
- Tap the three circles icon -> Location -> Routes

Packages Used:
- flutter_polyline_points - Used for implementing the polylines.
- google_maps_flutter - Used for displaying the google maps and functionalities related to it.
- location - Used for getting the current location of user and listening to real time location changes.
- flutter_svg - Used for loading and rendering svg files.

# Demo
https://user-images.githubusercontent.com/75658617/186592828-c464886c-222f-42f5-8ced-51baadfb232b.mp4
