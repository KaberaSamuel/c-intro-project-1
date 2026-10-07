# Smart Parking System

## What it does

An Arduino Uno reads an HC-SR04 ultrasonic sensor. At 20 cm or closer, the space is occupied: the red LED turns on and the buzzer sounds. Farther away, the green LED turns on. A missing echo is treated as an available space, and the serial monitor reports it.

## Files and wiring

- [Open the Tinkercad circuit](https://www.tinkercad.com/things/5Oco2Zb6GjI/editel).
- `src/smart_parking.ino` contains the Arduino sketch.
- `screenshots/data-flow.svg` shows the sensor, controller, decision, and outputs.
- `screenshots/wiring.svg` shows the pin connections for building the circuit.
- `screenshots/circuit-schematic.pdf` is the circuit schematic exported from Tinkercad.
- `screenshots/available-space.png` and `screenshots/occupied-space.png` show the two simulation states.

Connect HC-SR04 VCC to 5V, GND to GND, TRIG to pin 2, and ECHO to pin 3. Connect the green LED anode through a 220 ohm resistor to pin 8 and its cathode to GND. Connect the red LED anode through a 220 ohm resistor to pin 9 and its cathode to GND. Connect the buzzer positive lead to pin 10 and negative lead to GND. Share the Arduino ground.

The Tinkercad circuit uses one connected group of five holes on the mini breadboard for the output ground. The Arduino GND wire, both LED cathodes, and buzzer negative wire connect to separate holes in that same group.

## Component roles

| Component | Role |
|---|---|
| HC-SR04 sensor | Measures the echo time from the simulated vehicle. |
| Arduino Uno | Converts echo time to distance and compares it with 20 cm. |
| Green LED | Shows that the parking space is available. |
| Red LED | Shows that the parking space is occupied. |
| Two 220 ohm resistors | Limit the current through the LEDs. |
| Piezo buzzer | Sounds at 1000 Hz when the space is occupied. |
| Mini breadboard | Provides a common ground connection for the outputs. |

The 20 cm threshold suits this small demonstration: a close object represents a parked vehicle. A full-size installation would need a threshold chosen for its sensor position and parking space.

## Simulate in Tinkercad

Open the saved circuit and click **Start Simulation**. Click the ultrasonic sensor, then drag the blue target inside its detection cone to change the distance. Check the LEDs and buzzer. Open **Code**, then **Serial Monitor**, to see the calculated distance. The saved text code matches `src/smart_parking.ino`.

| Test distance | Green LED | Red LED | Buzzer |
|---:|---|---|---|
| 23.3 cm | On | Off | Off |
| 9.8 cm | Off | On | On |

These are the distances shown by the sensor control in the screenshots. The calculated serial readings can differ slightly because the simulator varies the echo time. The code treats a calculated distance of exactly 20 cm as occupied.

The sensor sends a sound pulse and measures the returning echo time. The Arduino converts that time to distance with `time * 0.0343 / 2`, then compares it with the threshold. The LEDs show the space state and the buzzer alerts when it is occupied.

## Test status

The Arduino sketch compiled and both required states passed in Tinkercad on 7 October 2026. The screenshots show the running circuit, sensor distance, LED states, and buzzer activity. The PDF is the Tinkercad schematic. The SVG files are design and data-flow diagrams.
