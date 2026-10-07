# Delivery Route Analysis

## What it does

The program stores up to 100 nonnegative whole-kilometre distances. It reports the total, average, longest route, number of routes over a chosen limit, and a recursive sum. The average calls the total-distance function, showing function reuse.

`total_distance` adds the values. `average_distance` reuses that total. `longest_distance` finds the largest value, and `count_above_limit` counts routes over the chosen limit.

The recursive sum stops at zero remaining routes. Each call adds the last distance and recurses with one fewer route. Recursion expresses the shrinking sum clearly, but each call uses stack space.

## Build and run

From this folder, compile with a C compiler:

```sh
gcc -std=c11 -Wall -Wextra -pedantic src/main.c -o route_analysis
./route_analysis
```

On Windows, run `route_analysis.exe` after compiling.

## Example run

```text
Number of routes (1-100): 6
Distance for route 1 (km): 12
Distance for route 2 (km): 25
Distance for route 3 (km): 18
Distance for route 4 (km): 40
Distance for route 5 (km): 15
Distance for route 6 (km): 30
Count routes longer than (km): 20

Delivery Route Report
Total distance: 140 km
Average distance: 23.33 km
Longest route: 40 km
Routes longer than 20 km: 3
Recursive sum: 140 km
```

Try one route at a time, a distance of zero, and the 100-route limit. Also check that zero routes, more than 100 routes, negative distances, values outside the `int` range, and nonnumeric input are rejected. The test suite also checks totals beyond the 32-bit range.

## Run evidence

[output.png](screenshots/output.png) shows the six-route sample run. [output.txt](screenshots/output.txt) has the captured program output. [console-session.txt](screenshots/console-session.txt) shows the inputs with that output.

The program compiled with Android NDK Clang and ran on an x86_64 Android emulator. It passed checks for the sample results, a full 100-route array, large totals, and invalid input.
