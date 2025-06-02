# Assembly Instructions
This document will provide a guide to assembling the ScopeFace Digital Stethoscope. To begin, please review the BOM and ensure you have all of these parts. You will also need 22 AWG Wire, a Soldering Iron, Electrical Tape, PET-G, and a 3D Printer.

First, we will do some preparation work:
1. Solder pieces of 22 AWG wire (longer than you think you'll need) to the following pins of the microphone evaluation board: WS, SCK, Data, GND, VDD. Try to use different colors for easy distinguishing.
2. Solder the Male to Female Battery connector to the XIAO ESP32-S3. Ensure to solder the correct leads. See [here](https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/#battery-usage) for specific instructions.
3. Desolder the button wires and solder them so they go upwards rather than straight outwards. This will help with space management.
4. Solder resistors to the LED leads (only Red and Green). Clip off the Blue lead.

Now we can put together the parts:
1. Print all of the parts found in /printing-files on your 3D Printer in PET-G
2. Take the heated threaded inserts and place them inside the holes on the Diaphragm and Mic Mount. They should slide in all the way except the top section which is not tapered. Using a soldering iron, set these inserts into the part so they are flush with the top surface of the standoffs.
3. Slide the battery into the Battery Mount. Ensure that the wire lead faces the inside of the body and slide it through the small opening to have the wires stick out as the battery sits inside the part.
4. Slide the mic evaluation board into the slot on the Diaphragm and Mic Mount. It should press fit (it is VERY tight so be absolutely sure the pick up hole on the mic board lines up with the hole on the part before pressing it down).
5. Stack the ESP32 Mount and the Battery Mount on top of the Diaphragm and Mic Mount. Using the M2-0.4 x 12 mm bolts secure these parts together using diagonal holes (2 of the four slots). IMPORTANT: route the wires from the battery on the inside of the standoffs so that it sits tightly between the Battery Mount and the standoffs.
6. Place the XIAO ESP32-S3 into the ESP32 Mount. It should slide in and be held in place. Solder the mic evaluation board WS, SCK, and Data cables (see the wiring diagram for specific pins).
7. Take Casing Cover and slide the push button into its slot.
8. Solder the 3.3V power to the microphone board cable (VDD) and the push button NEGATIVE lead.
9. Solder the push button POSITIVE lead to its GPIO pin (see [wiring diagram](https://github.com/sbogh/digital-stethoscope/blob/hardware/hardware/design/Wiring%20Diagram.png)).
10. Slide the LED into its slot. Solder the red and green pins to their respective GPIO ports (see [wiring diagram](https://github.com/sbogh/digital-stethoscope/blob/hardware/hardware/design/Wiring%20Diagram.png)).
11. Solder GND to the microphone board (GND) and the LED common ground pin.
12. Attach the antenna to the XIAO ESP32-S3. ([link](https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/#installation-of-antenna))
13. Line up the USB-C opening on the Casing Cover to the XIAO ESP32-S3 port (the button should be opposite to this face) and slide the cover on. It will be tight so be careful to ensure no pinched wires.
14. Use the M2-0.4 X 25 mm bolts to secure the Casing Cover to the heated threaded inserts.
15. Slide the stethoscope diaphragm cover onto the Diaphragm and Mic Mount. It will stretch onto the bottom lip.

Now you can enjoy your ScopeFace Stethoscope!
