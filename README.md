## Foursquare_clone_app


Foursquare_clone_app is my pet-project. This is a stripped-down version of the Foursquare app with some of my functionality different from the original version.
The application is based on the MVC pattern. The project is divided into modules that are implemented through a router. Also worked in practice with Networking, CoreLocation, MapKit, Keychain.

## Description

### The home screen of the application is the HomeViewController:

![Screenshot 2021-03-05 at 11 12 52](https://user-images.githubusercontent.com/61950177/110099698-46c28e80-7daa-11eb-8ab3-331290da3797.png)

* Image is uploaded via Kingfisher.
* The label in the picture displays the coordinates of the user.
* By clicking on the search button or on one of the standard categories, we get to the search screen.
* If the user has not allowed to use the data about his location, then the default coordinates are used.

### Search screen:

![Screenshot 2021-03-05 at 11 23 26](https://user-images.githubusercontent.com/61950177/110106126-f5b69880-7db1-11eb-9ac5-1e77036c06dc.png)

* By clicking on the place you need, we are prompted to select a controller option to display detailed information about the place.

![Screenshot 2021-03-05 at 12 59 16](https://user-images.githubusercontent.com/61950177/110106682-a58c0600-7db2-11eb-8ef0-cac38e8dbd8c.png)

### Detail screen:

* With ScrollView:

![Screen_Recording_2021-03-05_at_13 05 36](https://user-images.githubusercontent.com/61950177/110108079-68287800-7db4-11eb-99a8-c8ddef337a94.gif)

* With TableView:

![Screen_Recording_2021-03-05_at_13 13 15](https://user-images.githubusercontent.com/61950177/110108362-c48b9780-7db4-11eb-9fb5-d76d6bf947ac.gif)

    * There is a bug with a button for showing detailed information about the operating time.

* Did tap on the picture to open the screen for full screen view of the picture

### Map Screen: 

![Screen_Recording_2021-03-05_at_19 29 57](https://user-images.githubusercontent.com/61950177/110152219-20bcde80-7dea-11eb-8785-b97fa197ef64.gif)

### FullScreenImageViewController:

![Screen_Recording_2021-03-05_at_13 33 32-2](https://user-images.githubusercontent.com/61950177/110148474-85296f00-7de5-11eb-84f0-6e588ececa36.gif)

### Profile tab is AccountViewController: 

When the user is not logged in, the initial state of the controller is displayed:

![Screenshot 2021-03-05 at 11 13 12](https://user-images.githubusercontent.com/61950177/110100467-1d563280-7dab-11eb-8dc9-9f3b45b71b37.png)

* Did presed on the "Login" button opens the SFSafariViewController with the original Foursquare site. After authorization, we return to the application and save the access token in the keychain.

When the user is logged in, the authorization state of the controller is displayed
After authorization, the download of user data begins

![Screenshot 2021-03-05 at 11 21 53](https://user-images.githubusercontent.com/61950177/110101648-7ffbfe00-7dac-11eb-8692-315fc6a7f080.png)

* Did pressed on the exit button, we remove the access token and log out of the user account.
* By clicking on the button more (in the upper right corner) opens the settings screen.

### Settings screen:

![Screenshot 2021-03-05 at 12 25 57](https://user-images.githubusercontent.com/61950177/110102924-0238f200-7dae-11eb-9992-b18d8125796d.png)

* The switch activates local notifications.
* The "About Us" button opens a controller with a WebView and displays the apple site.
* The "Operating Conditions" button opens the controller with WebView and displays the local PDF file.
* The "Privacy" button opens a controller with a TextView and displays the text formatted via attributes. 

### Lists tab - ListsViewController:

![Screenshot 2021-03-05 at 11 22 14](https://user-images.githubusercontent.com/61950177/110104628-0fef7700-7db0-11eb-9e9e-81570e0ecd42.png)

* Without authorization, the user cannot create new lists.

### When creating a list, a custom alert appears:

![Screenshot 2021-03-05 at 11 22 51](https://user-images.githubusercontent.com/61950177/110104992-81c7c080-7db0-11eb-9880-199a86dd22f3.png)

* After clicking the create button, we make a post request to the server.
