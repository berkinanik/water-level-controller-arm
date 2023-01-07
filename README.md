# Water Level Controller System

## Overview

This project is part of the EE447 course at Middle East Technical University (METU). The goal of the project is to build a water level controller system based on an obtained water level signal. The system will continuously sense the water level using a sensor, and try to keep the water level in a predefined range using two water pumps. The current configuration and measurements will be displayed on a Nokia 5110 LCD screen, and the on-board RGB LED will also provide visual feedback on the water level.

---

_This assignment's instructions credit to [**Middle East Technical University - Electrical - Electronics Engineering Department**](https://eee.metu.edu.tr/) and [**METU EE447 Introduction to Microprocessors Course Lecturers**](https://catalog.metu.edu.tr/course.php?course_code=5670447)._

---

### Requirements and Restrictions

The system has the following requirements and restrictions:

- The system should have one constant range (i.e. low and high range limits).
- If the water is below the range, the red LED must be on and the others must be off.
- If the detected water level is in the range, the green LED should be on.
- (BONUS) When the green LED is on, its brightness can change proportional to the current water level. That is, the LED should light up less in low water and more in high water levels.
- If the detected water level exceeds the range, the blue LED should be on.
- The user should be able to see the configured range on the screen.
- The user should be able to see the current water level on the screen.
- The user must set the range (low and high limits) using a potentiometer.
- (BONUS) The user may also set the range by entering decimal digits using a 4x4 keypad.

### Hardware and Software Used

The following hardware and software will be used in this project:

- Keil uVision 5
- TM4C microcontroller
- Water level sensor
- Nokia 5110 LCD screen
- Two water pumps
- On-board RGB LED
- Potentiometer (optional)
- 4x4 keypad (optional)
- TivaWare software library

### Project Structure

The project code is organized as follows:

- `src/main.c`: main entry point and overall system control
- `src/sensors.c`: functions for interacting with the water level sensor
- `src/pumps.c`: functions for controlling the water pumps
- `src/display.c`: functions for displaying information on the LCD screen
- `src/led.c`: functions for controlling the RGB LED
- `src/potentiometer.c`: functions for reading the potentiometer (optional)
- `src/keypad.c`: functions for reading the 4x4 keypad (optional)

### How to Build and Run

1. Clone the repository to your local machine.
2. Open the project in Keil uVision5.
3. Build the project and load it onto the TM4C microcontroller.
4. Connect the hardware components as specified in the schematic.
5. Run the code on the microcontroller.

---

### Contributions

This project was completed by Berkin Anık.

### License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0) license. See the [LICENSE](LICENSE) file for details.
