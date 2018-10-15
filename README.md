#  iOS Instagram similar App for Unimelb 2018 COMP90018 Assignment 2

Reference: http://zero2launch.io/p/swift-4-firebase-4-clone-instagram

## How to setup the environment?

1. Download the files from the Github
2. Please request the "GoogleService-Info.plist" file from me or download a new one from Firebase API, and copy it into the folder "Resources", we do not push it into Github, so that the attackers cannot know our Firebase address.
3. Use Terminal, locate the source code base folder, run "pod install", install all the dependencies for the project use. (Some of the libraries may not download from the Github, it is safe to install manually)
        P.S. Please do not change the "Podfile" in the base folder, the libraries may not install as wrongly configure the files

4. run "open LikeIns.xcworkspace", not run "LikeIns,xcodeproj", because the dependencies cannot load correctly.

## How to run the app?

After done the previous work, 

![alt text](https://github.com/royli1118/LikeIns/blob/master/SignInformation.png)

Please select the automatically manage signing.
Please add an developer account in the Xcode, and select a team.

Then, simply build the entire project by clicking the running icon on the top left corner.
