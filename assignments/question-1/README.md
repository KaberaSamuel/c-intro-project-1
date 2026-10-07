# Water Quality Monitoring System

## What it does

The C program reads temperature and turbidity, calculates a water-quality index, and labels it Good, Warning, or Critical. Turbidity must be zero or greater.

The calculation is `100 - (abs(temperature - 25) + turbidity / 2)`. Good starts at 80, Warning starts at 60, and lower values are Critical.

`calculate_index` works out the score. `classify_water` chooses the matching status.

## Build and run

From this folder, compile with a C compiler:

```sh
gcc -std=c11 -Wall -Wextra -pedantic src/main.c -lm -o water_quality
./water_quality
```

On Windows, run `water_quality.exe` after compiling. `-lm` links the math functions used for the absolute value.

## Example run

```text
Temperature (C): 25
Turbidity (NTU): 10

Water Quality Report
--------------------
Temperature: 25.0 C
Turbidity:   10.0 NTU
Index:       95.0
Status:      Good
```

## Checks to run

At 25 C, turbidity 40 gives index 80 and Good. Turbidity 40.2 gives 79.9 and Warning. Turbidity 80 gives 60 and Warning. Turbidity 80.2 gives 59.9 and Critical. Also try text instead of a temperature and a negative turbidity; both should be rejected.

## Notes for the assignment

C is used in embedded devices such as sensor controllers because it gives direct control over hardware and can run with limited memory. A syntax error such as a missing semicolon breaks C grammar and is reported by the compiler. A semantic error such as using `temperature + 25` instead of `temperature - 25` is valid syntax but calculates the wrong value.

The build lifecycle is preprocessing (source and directives to expanded source), compilation (expanded source to assembly), assembly (assembly to object code), and linking (object files and libraries to an executable).

## Run evidence

[output.png](screenshots/output.png) shows the sample run for 25 C and 10 NTU. [output.txt](screenshots/output.txt) has the captured program output. [console-session.txt](screenshots/console-session.txt) shows the inputs with that output.

The program compiled with Android NDK Clang and ran on an x86_64 Android emulator. It passed checks for the Good, Warning, and Critical boundaries, plus invalid and non-finite inputs.
