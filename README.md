# digital-stethoscope

### Frontend
The digital-stethoscope contains the frontend. Do not rename or his will break things.
### Frontend Setup:
1. Make sure you have Xcode downloaded on your computer.
2. The app is nested in folders of the same name. When you clone the respository, be sure to open digital-stethoscope/digital-stethoscope
3. Firebase SDK: You must install the firebase SDK on your own machine.
    3.1 Navigate to the Project icon and right click (the first digital-stethoscope)
    3.2 Click on "Add Package Dependencies"
    3.3 In the search bar that pops up, past this link: https://github.com/firebase/firebase-ios-sdk
    3.4 Click "Add Package"
    3.5 Then look through the list, adding Firebase Auth, Firebase Core, and Firebase FireStore to the target, which is just digital stethoscope
4. Info.plist: Click on the projet icon one more time
    4.1 Navigate to the target (the icon labeled digital-stethoscope)
    4.2 Go to build settings, at the top, and click "all"
    4.3 Then search for "Generate Info.plist File". It should be under "Packaging". Make sure it is turned to No.
    4.4 Below that, will be a field Info.plist File. Ensure the path to the Info file in the cell. 
5. Then you should be good to go!


#### Backend
1. Make sure to have FastAPI installed
2. Take a look at main.py to get an idea of how everything works.

