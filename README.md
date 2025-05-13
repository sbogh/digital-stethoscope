# ScopeFace: Digital Stethoscope

## Frontend
The frontend is contained in /digital-stethoscope. Please do not change the filename!

### Frontend Setup:
1. Make sure you have Xcode downloaded on your computer.
2. The app is nested in folders of the same name. When you clone the respository, be sure to open digital-stethoscope/digital-stethoscope
3. Firebase SDK: You must install the Firebase SDK on your own machine.
    1. Navigate to the Project icon and right click (the first digital-stethoscope)
    2. Click on "Add Package Dependencies"
    3. In the search bar that pops up, paste this link: https://github.com/firebase/firebase-ios-sdk
    4. Click "Add Package"
    5. Then look through the list, adding Firebase Auth, Firebase Core, and Firebase FireStore to the target, which is just digital-stethoscope
4. Info.plist: Click on the projet icon one more time
    1. Navigate to the target (the icon labeled digital-stethoscope)
    2. Go to build settings, at the top, and click "all"
    3. Then search for "Generate Info.plist File". It should be under "Packaging". Make sure it is turned to No.
    4. Below that, there will be a field Info.plist File. Ensure the path to the Info file in the cell. 
5. Then you should be good to go!


## Backend
1. Make sure to have FastAPI installed
2. Take a look at main.py to get an idea of how everything works.
3. use ```uvicorn main:app --reload``` to run the server

## Hardware

### Hardware Setup
1. Using the Arduino IDE, plug in your ESP32-S3-DevKitC-1-N16R8
2. Go to Tools -> PSRAM and enable "OPI PSRAM"
3. Add WiFi SSID and Password Information where specified in instruction comments
4. Add Firebase API Key and double check bucket and user authentication information
5. Compile and upload to microcontroller

### Hardware Operation
1. Wait for upload to complete and check for initialization success (serial monitor will display WiFi connected, Firebase connected)
2. Press button to record 30 seconds of audio (onboard RGB will be red)
3. Wait for Firebase upload to complete (onboard RGB will be green)
4. Navigate to Firebase to playback audio
